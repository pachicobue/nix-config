{delib, ...}:
delib.host {
  name = "pi4";
  system = "aarch64-linux";
  type = "server";
  features = [];

  myconfig = {...}: {
    agenix-rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA9WiYz2sJq45+f7CN0dP3Ag77ugQklmkDz4IcENeem7 root@nixos";
    state-version.nixos = "25.05";
    state-version.home = "25.05";
    boot.loader = "extlinux";
    networking = {useDHCP = true;};
    services.adguardhome = {
      enable = true;
    };
  };
}
