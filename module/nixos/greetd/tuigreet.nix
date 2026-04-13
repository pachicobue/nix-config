{ delib, pkgs, lib, ... }:
delib.module {
  name = "tuigreet";
  options.tuigreet.enable = delib.boolOption false;
  nixos.ifEnabled = { myconfig, ... }:
    lib.mkIf (myconfig.host.desktop != "none") {
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            user = "greeter";
            command = "${lib.getExe pkgs.tuigreet} --time --remember --remember-session";
          };
        };
      };
    };
}
