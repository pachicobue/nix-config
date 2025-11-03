{...}: {
  services.freshrss = {
    enable = true;
    defaultUser = "admin";
    passwordFile = "/var/lib/freshrss/password";
    baseUrl = "http://berry.netbird.cloud";
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80];
  };
}
