{config, ...}: {
  age.secrets."silverbullet/token" = {
    file = ../secret/silverbullet/token.age;
    owner = "silverbullet";
  };
  services.silverbullet = {
    enable = true;
    listenPort = 3000;
    listenAddress = "127.0.0.1";
    openFirewall = false;
    envFile = config.age.secrets."silverbullet/token".path;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [];
  };
}
