{...}: {
  services.netbird = {
    ui.enable = false;
    useRoutingFeatures = "client";
    clients."homelab" = {
      autoStart = true;
      hardened = false;
      openFirewall = true;
      port = 51820;
    };
  };
}
