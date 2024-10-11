{
  config,
  username,
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
    };
  };
  # systemd.services.NetworkManager-wait-online.enable = false;
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
  users.users."${username}".extraGroups = [ "networkmanager" ];
}
