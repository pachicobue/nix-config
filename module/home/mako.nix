{ delib, lib, ... }:
delib.module {
  name = "mako";
  options.mako.enable = delib.boolOption false;
  home.ifEnabled = { myconfig, ... }:
    lib.mkIf (myconfig.host.desktop == "wayland") {
      services.mako = {
        enable = true;
        settings = {
          default-timeout = 5000;
        };
      };
    };
}
