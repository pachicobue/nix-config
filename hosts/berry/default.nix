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
      secrets = ["forgejo-runner" "restic-password" "restic-env" "uptime-kuma-push"];
    };
    boot.loader = "limine";
    networking.wakeOnLan = true;

    services = {
      vaultwarden = {
        enable = true;
        # 初回アカウント作成後に false に戻す
        signupsAllowed = true;
        backupRepositories = {
          pi4 = "rest:http://pi4:8000/vaultwarden";
          # Cloudflare R2 を用意したら有効化し、`agenix edit restic-env` で API キーを入れる
          # r2 = "s3:https://<account-id>.r2.cloudflarestorage.com/<bucket>";
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
