{
  delib,
  config,
  ...
}:
delib.host {
  name = "berry";
  system = "x86_64-linux";
  type = "server";
  features = [];

  nixos = {
    age.secrets.obsidian-livesync.rekeyFile = ../../secrets/obsidian-livesync.age;
  };
  myconfig = {myconfig, ...}: let
    secrets = config.age.secrets;
  in {
    state-version.nixos = "25.05";
    state-version.home = "25.05";
    agenix-rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDYQA2MdJUMuWPQSQwv/ABoovP9cyxpq/t0vLUIJgGgs root@berry";
      secrets = ["obsidian-livesync"];
    };
    boot.loader = "limine";
    services = {
      immich = {
        enable = true;
        bindHost = "0.0.0.0";
        mediaLocation = "/media/immich";
      };
      obsidianLivesync = {
        enable = true;
        bindAddress = "0.0.0.0";
        adminPassFile = myconfig.agenix-rekey.secretPaths.obsidian-livesync;
      };
    };
  };
}
