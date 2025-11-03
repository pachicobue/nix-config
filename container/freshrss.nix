{...}: {
  services.freshrss = {
    enable = true;
    defaultUser = "admin";
    passwordFile = "/var/lib/freshrss/password";
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 ];
  };
}
