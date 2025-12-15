{config, ...}: {
  age.secrets."writefreely-pass" = {
    file = ../secrets/writefreely-pass.age;
    owner = "writefreely";
  };
  services.writefreely = {
    enable = true;
    host = "https://pachicobue.org";

    admin = {
      name = "sho";
      initialPasswordFile = config.age.secrets."writefreely-pass".path;
    };

    settings = {
      server = {
        port = 8080;
        bind = "0.0.0.0";
      };

      database = {
        type = "sqlite3";
        filename = "/var/lib/writefreely/writefreely.db";
      };

      app = {
        site_name = "Bue.js";
        site_description = "Pachicobue's page";
        host = "https://pachicobue.org";
        single_user = true;
        monetization = false;
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [8080];
  };
}
