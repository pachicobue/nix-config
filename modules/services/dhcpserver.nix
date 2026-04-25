{
  delib,
  pkgs,
  host,
  lib,
  ...
}:
delib.module {
  name = "services.dhcp-server";
  options = delib.singleEnableOption host.dhcpServerFeatured;
  nixos.ifEnabled = {
    networking = {
      useDHCP = false;
      interfaces = lib.mkIf (host.network.primaryNic != null) {
        ${host.network.primaryNic} = {
          ipv4.addresses = host.network.staticIp;
        };
      };
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
