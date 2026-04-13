{ delib, lib, ... }:
delib.module {
  name = "openssh";
  options.openssh.enable = delib.boolOption false;
  nixos.ifEnabled = { myconfig, ... }: {
    services.openssh = {
      enable = true;
      settings = {
        X11Forwarding = lib.mkIf (myconfig.host.desktop == "x") true;
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
      };
    };
    environment.enableAllTerminfo = true;
  };
}
