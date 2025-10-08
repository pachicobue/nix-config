{
  pkgs,
  lib,
  ...
}: let
  niriConfig = pkgs.writeText "niri-config.kdl" ''
    hotkey-overlay {
      skip-at-startup
    }
    environment {
      GTK_USE_PORTAL "0"
      GDK_DEBUG "no-portals"
    }
    spawn-at-startup "sh" "-c" "${lib.getExe pkgs.regreet}; niri msg action quit --skip-confirmation"
  '';
in {
  programs.regreet.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.niri} -c ${niriConfig}";
      };
    };
  };
}
