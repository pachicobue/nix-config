{config, ...}: {
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [config.services.tailscale.port];
      allowedTCPPorts = [22];
    };
  };
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
}
