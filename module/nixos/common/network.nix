{ delib, lib, pkgs, ... }:
delib.module {
  name = "nixos.network";
  nixos.always = { myconfig, ... }: let
    iface = myconfig.host.network.iface;
  in {
    networking = {
      useDHCP = myconfig.host.network.useDhcp;
      interfaces = lib.mkIf (iface.address != "") {
        ${iface.name} = {
          ipv4.addresses = [
            {
              address = iface.address;
              prefixLength = 24;
            }
          ];
        };
      };
      defaultGateway = lib.mkIf (!myconfig.host.network.useDhcp) myconfig.constants.network.gateway;
      firewall.enable = true;
    };
    programs.tcpdump.enable = true;
    environment.systemPackages = with pkgs; [
      tcpdump
      dnslookup
    ];
  };
}
