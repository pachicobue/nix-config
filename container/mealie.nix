{...}: {
  services.mealie = {
    enable = true;
    port = 9000;
    listenAddress = "0.0.0.0";
    settings = {
      BASE_URL = "http://berry:9000";
      TZ = "Asia/Tokyo";
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [9000];
  };
}
