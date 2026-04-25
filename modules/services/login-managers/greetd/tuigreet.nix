{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "internal.greetd.tuigreet";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    services.greetd = {
      useTextGreeter = true;
      settings = {
        default_session = {
          user = "greeter";
          command = "${lib.getExe pkgs.tuigreet} --asterisk --remember --remember-user-session";
        };
      };
    };
  };
}
