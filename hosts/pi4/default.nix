{delib, ...}:
delib.host {
  name = "pi4";
  system = "aarch64-linux";
  type = "server";
  features = [];

  myconfig = {...}: {
    agenix-rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA9WiYz2sJq45+f7CN0dP3Ag77ugQklmkDz4IcENeem7 root@nixos";
      secrets = [
        "vaultwarden-backup-password"
        "vaultwarden-restore-env"
        "healthchecks-ping-url"
      ];
    };
    state-version.nixos = "25.05";
    state-version.home = "25.05";
    boot.loader = "extlinux";
    networking = {useDHCP = true;};

    services = {
      wol-server = {
        enable = true;
        broadcastAddress = "192.168.0.255";
        devices = {
          berry = "68:1d:ef:37:e8:ab";
          coconut = "08:bf:b8:a5:74:f7";
        };
      };
      # pi4 自体 (と Uptime Kuma) が落ちたことを外から検知する
      healthchecks-ping.enable = true;
      uptime-kuma = {
        enable = true;
        bindHost = "0.0.0.0";
      };
      # berry のバックアップから毎晩復元できることを確認する
      vaultwarden = {
        enable = true;
        restoreFrom = "s3:https://c112258359f224535dcc3ad32359f195.r2.cloudflarestorage.com/vaultwarden-backup";
        restoreDrill = true;
        restoreDrillPushUrl = "http://127.0.0.1:3001/api/push/LoEc9Nu0mIABSSRbRwVJH0hjSemq4c3s";
      };
    };
  };
}
