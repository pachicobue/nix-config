{config, ...}: {
  age.secrets."writefreely/admin-pass" = {
    file = ../secrets/writefreely/admin-pass.age;
    owner = "writefreely";
  };
  services.writefreely = {
    enable = true;
    host = "blog.pachicobue.org";

    admin = {
      name = "pachicobue";
      initialPasswordFile = config.age.secrets."writefreely/admin-pass".path;
    };

    settings = {
      server = {
        port = 8081;
        bind = "0.0.0.0";
      };

      database = {
        type = "sqlite3";
        filename = "writefreely.db";
      };

      app = {
        site_name = "Bue.js";
        site_description = "雑記";
        host = "https://blog.pachicobue.org";
        single_user = true;
        monetization = false;
        federation = false;
        wf_modesty = true;
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [8081];
  };
}
