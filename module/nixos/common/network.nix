{
  lib,
  pkgs,
  commonConfig,
  hostConfig,
  ...
}: let
  iface = hostConfig.network.iface;
in {
  networking = {
    useDHCP = hostConfig.network.useDhcp;
    interfaces = lib.mkIf (builtins.hasAttr "address" iface) {
      ${iface.name} = {
        ipv4.addresses = [
          {
            address = iface.address;
            prefixLength = 24;
          }
        ];
      };
    };
    defaultGateway = {
      address = commonConfig.network.gateway;
    };
    firewall.enable = true;
    nameservers = commonConfig.network.dns;
  };
  programs.tcpdump.enable = true;
  environment.systemPackages = with pkgs; [
    tcpdump
    wget2
    curl
    bandwhich
    gping
    dog
    socat
  ];
}
