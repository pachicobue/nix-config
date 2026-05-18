{delib, ...}:
delib.host {
  name = "pi4";
  system = "aarch64-linux";
  type = "server";
  features = [];

  myconfig = {...}: {
    state-version.nixos = "25.05";
    state-version.home = "25.05";
    boot.loader = "extlinux";
    networking = {
      useDHCP = false;
      defaultGateway = "192.168.10.1";
      nameservers = ["1.1.1.1"];
      staticIp = {"eno1" = "192.168.10.181/24";};
    };
  };

  nixos = {...}: {
    # Containerサービス
    containers.adguardhome = {
      autoStart = true;
      config = {...}: {
        system.stateVersion = "25.05";
        imports = [
          ../../container/adguardhome.nix
        ];
      };
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        53 # DNS
        67 # DHCP
        68 # DHCP
        3000 # AdGuardHome Web UI
      ];
      allowedUDPPorts = [
        53 # DNS
        67 # DHCP
        68 # DHCP
      ];
    };
  };
}
