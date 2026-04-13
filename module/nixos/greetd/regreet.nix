{ delib, pkgs, lib, ... }:
delib.module {
  name = "regreet";
  options.regreet.enable = delib.boolOption false;
  nixos.ifEnabled = { myconfig, ... }:
    lib.mkIf (myconfig.host.desktop == "wayland") {
      programs.regreet.enable = true;
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            user = "greeter";
            command = "${lib.getExe pkgs.cage} -s -m last -- ${lib.getExe pkgs.regreet}";
          };
        };
      };
    };
}
