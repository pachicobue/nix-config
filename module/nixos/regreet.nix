{
  pkgs,
  lib,
  config,
  hostConfig,
  ...
}: let
  sessionDir = "${config.services.displayManager.sessionData.desktops}/share";
  sessionDirs = "${sessionDir}/xsessions:${sessionDir}/wayland-sessions";
in
  lib.mkIf (hostConfig.desktop == "wayland") {
    programs.regreet.enable = true;
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = "greeter";
          command = "env SESSION_DIRS=${sessionDirs} ${lib.getExe pkgs.cage} -s -m last -- ${lib.getExe pkgs.regreet}";
        };
      };
    };
  }
