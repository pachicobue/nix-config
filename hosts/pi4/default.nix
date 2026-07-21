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

    services = {
      adguardhome = {
        enable = true;
      };
      rustdesk = {
        enable = true;
        relayHosts = ["pi4"];
      };
      wol-server = {
        enable = true;
        broadcastAddress = "192.168.0.255";
        devices = {
          berry = "68:1d:ef:37:e8:ab";
          coconut = "08:bf:b8:a5:74:f7";
        };
      };
    };
  };
}
