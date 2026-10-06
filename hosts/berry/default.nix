{delib, ...}:
delib.host {
  name = "berry";
  system = "x86_64-linux";
  type = "server";
  features = [];

  myconfig = {...}: {
    state-version.nixos = "25.05";
    state-version.home = "25.05";
    agenix-rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDYQA2MdJUMuWPQSQwv/ABoovP9cyxpq/t0vLUIJgGgs root@berry";
      secrets = [
        "forgejo-runner"
        "vaultwarden-backup-password"
        "vaultwarden-backup-env"
      ];
    };
    boot.loader = "limine";
    networking.wakeOnLan = true;

    services = {
      vaultwarden = {
        enable = true;
        # 初回アカウント作成後に false に戻す
        signupsAllowed = false;
        backupRepositories = {
          r2 = "s3:https://c112258359f224535dcc3ad32359f195.r2.cloudflarestorage.com/vaultwarden-backup";
        };
      };
      immich = {
        enable = true;
        bindHost = "0.0.0.0";
        mediaLocation = "/media/immich";
      };
      forgejo = {
        enable = true;
        bindHost = "0.0.0.0";
      };
      forgejo-runner = {
        enable = true;
        uuid = "675e14c5-1b28-4ad9-8559-a1728afe7b14";
      };
    };
  };
}
