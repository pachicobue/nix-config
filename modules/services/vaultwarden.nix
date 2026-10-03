{
  delib,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "services.vaultwarden";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      domain = strOption "";
      signupsAllowed = boolOption false;
      # バックアップ先の restic リポジトリ (名前 -> URL)。空なら何もしない
      # 例: { pi4 = "rest:http://pi4:8000/vaultwarden";
      #       r2 = "s3:https://<account-id>.r2.cloudflarestorage.com/<bucket>"; }
      # 共通のパスワードは restic-password、S3 等の認証情報は restic-env シークレットに置く
      # 結果は Uptime Kuma の Push モニタへ送る。URL は uptime-kuma-push シークレットに
      # PUSH_URL_<NAME を大文字化> (例: PUSH_URL_PI4=https://...) の形で置き、未設定なら送らない
      backupRepositories = attrsOption {};
    };

  nixos.ifEnabled = {
    cfg,
    myconfig,
    ...
  }: let
    port = 8222;
    # services.vaultwarden.backupDir を設定すると、sqlite3 .backup で整合性の取れた
    # DB コピーと添付ファイル等をここに書き出す backup-vaultwarden.service が生える
    backupDir = "/var/backup/vaultwarden";
    jobName = name: "vaultwarden-${name}";
    forEachBackup = f: lib.mapAttrs' f cfg.backupRepositories;
    pushUrlVar = name: "PUSH_URL_" + lib.toUpper (builtins.replaceStrings ["-"] ["_"] name);
    # postStop として成功/失敗どちらでも走る。$SERVICE_RESULT は systemd が ExecStopPost に渡す
    notifyScript = name: ''
      #!${pkgs.runtimeShell}
      set -eu
      . ${myconfig.agenix-rekey.secretPaths.uptime-kuma-push}
      url="''${${pushUrlVar name}:-}"
      [ -n "$url" ] || exit 0
      if [ "$SERVICE_RESULT" = success ]; then
        status=up msg=OK
      else
        status=down msg=$SERVICE_RESULT
      fi
      ${lib.getExe pkgs.curl} -fsS -m 10 -o /dev/null "$url?status=$status&msg=$msg"
    '';
  in {
    services.vaultwarden = {
      enable = true;
      domain =
        if cfg.domain == ""
        then null
        else cfg.domain;
      inherit backupDir;
      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = port;
        SIGNUPS_ALLOWED = cfg.signupsAllowed;
      };
    };

    # 手動操作用の restic-vaultwarden-<name> コマンドも生える (createWrapper)
    services.restic.backups = forEachBackup (name: repository:
      lib.nameValuePair (jobName name) {
        inherit repository;
        backupCleanupCommand = notifyScript name;
        passwordFile = myconfig.agenix-rekey.secretPaths.restic-password;
        environmentFile = myconfig.agenix-rekey.secretPaths.restic-env;
        paths = [backupDir];
        initialize = true;
        pruneOpts = ["--keep-daily 14" "--keep-weekly 8" "--keep-monthly 12"];
        timerConfig = {
          OnCalendar = "23:30";
          Persistent = true;
        };
      });

    systemd.services =
      # restic 実行前に backupDir の内容を最新化する
      forEachBackup (name: _:
        lib.nameValuePair "restic-backups-${jobName name}" {
          requires = ["backup-vaultwarden.service"];
          after = ["backup-vaultwarden.service"];
        })
      // {
        vaultwarden-tailscale-serve = {
          description = "Serve Vaultwarden over Tailscale HTTPS";
          after = ["tailscaled.service" "vaultwarden.service"];
          requires = ["vaultwarden.service"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            Restart = "on-failure";
            RestartSec = 10;
            ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg --https=443 http://127.0.0.1:${toString port}";
            ExecStop = "${pkgs.tailscale}/bin/tailscale serve --https=443 off";
          };
        };
      };
  };
}
