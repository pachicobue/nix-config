{config, ...}: {
  age.secrets."freshrss/password" = {
    file = ../secrets/freshrss/password.age;
    owner = "writefreely";
  };
  services.freshrss = {
    enable = true;
    baseUrl = "https://berry.tail414be6.ts.net/";
    defaultUser = "sho";
    passwordFile = config.age.secrets."freshrss/password".path;
    language = "ja";
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [8080];
  };
}
