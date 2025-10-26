{...}: {
  services.netbird = {
    useRoutingFeatures = "client";
    clients."homelab" = {
      autoStart = true;
      hardened = true;
      openFirewall = true;
      port = 51820;
    };
  };
}
