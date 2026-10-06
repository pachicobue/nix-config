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
      # 例: { r2 = "s3:https://<account-id>.r2.cloudflarestorage.com/<bucket>"; }
      # 共通のパスワードは vaultwarden-backup-password、S3 等の認証情報は
      # vaultwarden-backup-env シークレットに置く
      backupRepositories = attrsOption {};
      # 立て直し用: データディレクトリが空のとき、起動前にこの restic リポジトリの
      # 最新スナップショットから復元する。空文字なら何もしない
      # パスワードは vaultwarden-backup-password、認証情報は読み取り専用で足りるので
      # vaultwarden-restore-env シークレットに置く
      restoreFrom = strOption "";
      # 復元訓練用: 普段は vaultwarden を起動せず、毎晩データを消して restoreFrom から
      # 復元・起動・応答確認をしてから停止する。本番の災害復旧と同じ経路を通す
      restoreDrill = boolOption false;
      # 復元訓練の結果を送る Uptime Kuma の Push モニター URL。空なら送らない
      # 例: "http://127.0.0.1:3001/api/push/<token>"
      # UI からコピーした URL に付く ?status=up&msg=OK&ping= は無視して結果で上書きする
      restoreDrillPushUrl = strOption "";
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
    # nixpkgs の vaultwarden は stateVersion >= 24.11 でこのディレクトリを使う
    dataDir = "/var/lib/vaultwarden";
    restoreDir = "/var/lib/vaultwarden-restore";
    jobName = name: "vaultwarden-${name}";
    forEachBackup = f: lib.mapAttrs' f cfg.backupRepositories;
    # 読み取り専用トークンではロックファイルを作れないため restic は --no-lock で使う
    restoreEnvironment = {
      RESTIC_REPOSITORY = cfg.restoreFrom;
      RESTIC_PASSWORD_FILE = myconfig.agenix-rekey.secretPaths.vaultwarden-backup-password;
      RESTIC_CACHE_DIR = "/var/cache/vaultwarden-restore";
    };
    restoreEnvironmentFile = myconfig.agenix-rekey.secretPaths.vaultwarden-restore-env;
    # 最新スナップショットがこれより古ければ本番のバックアップが止まっているとみなす
    maxSnapshotAge = 2 * 24 * 60 * 60;
  in {
    assertions = [
      {
        assertion = cfg.restoreDrill -> cfg.restoreFrom != "";
        message = "vaultwarden: restoreDrill requires restoreFrom";
      }
      {
        assertion = cfg.restoreDrill -> cfg.backupRepositories == {};
        message = "vaultwarden: restoreDrill host must not back up the restored data";
      }
    ];

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
        passwordFile = myconfig.agenix-rekey.secretPaths.vaultwarden-backup-password;
        environmentFile = myconfig.agenix-rekey.secretPaths.vaultwarden-backup-env;
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
          # 復元失敗時などデータが無い状態で空のスナップショットを作らない
          unitConfig.ConditionPathExists = "${dataDir}/db.sqlite3";
        })
      // lib.optionalAttrs (!cfg.restoreDrill) {
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
      }
      // lib.optionalAttrs (cfg.restoreFrom != "") {
        # 失敗したら空のまま起動しないよう requiredBy で vaultwarden を止める
        # データが既にあれば Condition で skip 扱いになり、vaultwarden はそのまま起動する
        vaultwarden-restore = {
          description = "Restore Vaultwarden data from restic backup";
          requiredBy = ["vaultwarden.service"];
          before = ["vaultwarden.service"];
          after = ["network-online.target"];
          wants = ["network-online.target"];
          unitConfig.ConditionPathExists = "!${dataDir}/db.sqlite3";
          path = with pkgs; [restic sqlite rsync coreutils];
          environment = restoreEnvironment;
          serviceConfig = {
            Type = "oneshot";
            EnvironmentFile = restoreEnvironmentFile;
            CacheDirectory = "vaultwarden-restore";
            StateDirectory = "vaultwarden-restore";
            StateDirectoryMode = "0700";
          };
          script = ''
            set -euo pipefail

            find ${restoreDir} -mindepth 1 -delete
            restic --no-lock restore latest --target ${restoreDir}
            # バックアップは backupDir を丸ごと保存している
            src=${restoreDir}${backupDir}

            result=$(sqlite3 -readonly "$src/db.sqlite3" 'PRAGMA integrity_check;')
            if [ "$result" != ok ]; then
              echo "integrity check failed: $result" >&2
              exit 1
            fi

            install -d -m 0700 -o vaultwarden -g vaultwarden ${dataDir}
            rsync -a --chown=vaultwarden:vaultwarden "$src/" ${dataDir}/
            find ${restoreDir} -mindepth 1 -delete
          '';
        };
      }
      // lib.optionalAttrs cfg.restoreDrill {
        vaultwarden.wantedBy = lib.mkForce [];

        vaultwarden-restore-drill = {
          description = "Verify Vaultwarden can be restored from restic backup";
          after = ["network-online.target"];
          wants = ["network-online.target"];
          path = with pkgs; [restic sqlite jq curl coreutils systemd];
          environment = restoreEnvironment;
          serviceConfig = {
            Type = "oneshot";
            EnvironmentFile = restoreEnvironmentFile;
          };
          script = ''
            set -euo pipefail

            # set -e で想定外に落ちたときはこのメッセージで通知する
            msg="drill failed (see journalctl -u vaultwarden-restore-drill)"
            fail() {
              echo "$1" >&2
              msg=$1
              exit 1
            }
            on_exit() {
              status=$?
              systemctl stop vaultwarden.service
              ${lib.optionalString (cfg.restoreDrillPushUrl != "") ''
              if [ "$status" = 0 ]; then state=up; else state=down; fi
              curl -fsS -o /dev/null --retry 3 -G \
                --data-urlencode "status=$state" --data-urlencode "msg=$msg" \
                ${lib.escapeShellArg (lib.head (lib.splitString "?" cfg.restoreDrillPushUrl))} \
                || echo "failed to notify uptime-kuma" >&2
            ''}
              exit "$status"
            }
            trap on_exit EXIT

            # データを消して起動すると、requiredBy で vaultwarden-restore が走る
            systemctl stop vaultwarden.service
            if [ -d ${dataDir} ]; then
              find ${dataDir} -mindepth 1 -delete
            fi
            systemctl start vaultwarden.service \
              || fail "restore or startup failed (see journalctl -u vaultwarden-restore)"

            alive=0
            for _ in $(seq 30); do
              if curl -fsS -o /dev/null http://127.0.0.1:${toString port}/alive; then
                alive=1
                break
              fi
              sleep 2
            done
            if [ "$alive" != 1 ]; then
              fail "vaultwarden did not respond after restore"
            fi

            users=$(sqlite3 -readonly ${dataDir}/db.sqlite3 'SELECT count(*) FROM users;')
            if [ "$users" -lt 1 ]; then
              fail "restored database has no users"
            fi

            latest=$(restic --no-lock snapshots --latest 1 --json | jq -r 'max_by(.time) | .time')
            age=$(( $(date +%s) - $(date -d "$latest" +%s) ))
            if [ "$age" -gt ${toString maxSnapshotAge} ]; then
              fail "latest snapshot is too old: $latest"
            fi
            msg="restored snapshot from $latest ($users users)"
            echo "$msg"
          '';
        };
      };

    # 本番のバックアップ (23:30) の後に実行する
    systemd.timers = lib.optionalAttrs cfg.restoreDrill {
      vaultwarden-restore-drill = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "01:00";
          Persistent = true;
        };
      };
    };
  };
}
