{...}: {
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    mutableSettings = true;
    host = "0.0.0.0";
    port = 3000;
  };
}
