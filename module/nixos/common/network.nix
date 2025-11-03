{
  lib,
  pkgs,
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
    firewall.enable = true;
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
