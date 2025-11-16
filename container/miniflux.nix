{pkgs, ...}: {
  services.miniflux = {
    enable = true;
    createDatabaseLocally = true;
    adminCredentialsFile = "/var/lib/miniflux/admin-credentials";
    config = {
      LISTEN_ADDR = "0.0.0.0:8080";
      BASE_URL = "http://berry:8080";
    };
  };

  # PostgreSQLを有効化（createDatabaseLocallyで必要）
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [8080];
  };
}
