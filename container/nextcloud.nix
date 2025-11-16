{hostConfig, ...}: {
  services.nextcloud = {
    enable = true;
    hostName = hostConfig.name;

    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = "/var/lib/nextcloud/admin-pass";
    };
    settings = {
      trusted_domains = [
        "${hostConfig.name}.lan"
      ];
    };
    https = false;
  };

  services.postgresql = {
    enable = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80];
  };
}
