{config, ...}: {
  age.secrets."miniflux/admin-credentials" = {
    file = ../secrets/miniflux/admin-credentials.age;
    owner = "miniflux";
  };

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.age.secrets."miniflux/admin-credentials".path;
    config = {
      LISTEN_ADDR = "0.0.0.0:8080";
      BASE_URL = "https://berry.tail414be6.ts.net";
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [8080];
  };
}
