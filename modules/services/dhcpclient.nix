{
  delib,
  pkgs,
  host,
  lib,
  ...
}:
delib.module {
  name = "services.dhcp-client";
  options = delib.singleEnableOption host.dhcpClientFeatured;
  nixos.ifEnabled = {
    networking = {
      useDHCP = true;
      defaultGateway = lib.mkIf (host.network.defaultGateway != null) host.network.defaultGateway;
      firewall.enable = true;
    };
    programs.tcpdump.enable = true;
    environment.systemPackages = with pkgs; [
      tcpdump
      dnslookup
    ];
  };
}
