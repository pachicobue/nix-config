{
  config,
  hostname,
  ...
}:
{
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts = [
        22
        80
        443
        5900
      ];
    };
  };
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
    };
  };
}
