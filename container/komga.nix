{...}: {
  services.komga = {
    enable = true;
    openFirewall = true;
    settings = {
      server.port = 8080;
    };
  };
  networking.firewall.enable = true;
}
