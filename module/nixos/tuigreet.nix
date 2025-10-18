{
  pkgs,
  config,
  lib,
  hostConfig,
  ...
}: let
  sessionDir = "${config.services.xserver.displayManager.sessionData.desktops}/share";
  sessionDirs = "${sessionDir}/xsessions:${sessionDir}/wayland-sessions";
in
  lib.mkIf (hostConfig.desktop != "none") {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = "greeter";
          command = "${lib.getExe pkgs.tuigreet} --sessions ${sessionDirs} --remember-user-session";
        };
      };
    };
  }
