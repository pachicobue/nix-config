{
  lib,
  hostConfig,
  ...
}: {
  services.openssh = {
    enable = true;
    settings = {
      X11-Forwarding = lib.mkIf (hostConfig.desktop == "x") true;
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };
  services.fail2ban.enable = true;
  environment.enableAllTerminfo = true;
}
