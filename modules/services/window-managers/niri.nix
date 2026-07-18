{
  delib,
  host,
  pkgs,
  lib,
  inputs,
  ...
}: let
  niriAction = cmd: ["niri" "msg" "action"] ++ (lib.splitString " " cmd);
in
  delib.module {
    name = "services.windowManager.niri";
    options = with delib;
      moduleOptions {
        enable = boolOption false;
      };

    home.always = {
      imports = [inputs.niri-flake.homeModules.niri];
    };
    home.ifEnabled = {
      myconfig,
      cfg,
      ...
    }: let
      inherit (myconfig.commands.default) browser terminal launcher;
      pictureDir = myconfig.xdg.userDirs.pictures;
    in {
      imports = [inputs.niri-flake.homeModules.stylix];
      assertions = [
        {
          assertion = host.waylandFeatured;
          message = "[niri] Need 'wayland' feature.";
        }
        {
          assertion = browser != [];
          message = "[niri] Need default browser command to be set.";
        }
        {
          assertion = terminal != [];
          message = "[niri] Need terminal browser command to be set.";
        }
        {
          assertion = launcher != [];
          message = "[niri] Need launcher browser command to be set.";
        }
      ];

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
          gnome-keyring
        ];
        config.niri = {
          default = ["gnome" "gtk"];
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
          "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
        };
      };
      # Authentication agentは固定(こだわりなし)
      services.hyprpolkitagent.enable = true;
      services.gnome-keyring = {
        enable = true;
        components = ["pkcs11" "secrets"];
      };
      home.packages = with pkgs; [gcr];

      programs.niri = {
        enable = true;
        settings = {
          prefer-no-csd = false;
          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
          hotkey-overlay.skip-at-startup = true;
          cursor = {hide-when-typing = true;};
          input = {
            warp-mouse-to-focus.enable = true;
            focus-follows-mouse.enable = true;
            touchpad.dwt = true;
          };
          spawn-at-startup = [
            {command = browser;}
            {command = terminal;}
            {command = terminal;}
            {command = terminal;}
          ];
          layout = {
            gaps = 8;
            always-center-single-column = true;
            center-focused-column = "never";
            default-column-width = {proportion = 1. / 2.;};
            preset-column-widths = [
              {proportion = 1. / 2.;}
            ];
          };
          window-rules = [
            {
              geometry-corner-radius = {
                top-left = 20.0;
                top-right = 20.0;
                bottom-left = 20.0;
                bottom-right = 20.0;
              };
              clip-to-geometry = true;
              draw-border-with-background = false;
            }
          ];
          layer-rules = [
            {
              matches = [{namespace = "^noctalia-overview*";}];
              place-within-backdrop = true;
            }
          ];
          overview.workspace-shadow.enable = true;
          debug = {
            honor-xdg-activation-with-invalid-serial = {};
          };
          screenshot-path = "${pictureDir}/Screenshots/%Y%m%d_%H%M%s.png";

          binds = {
            "Mod+Shift+Slash" = {action.show-hotkey-overlay = [];};
            "Ctrl+Alt+Delete" = {action.quit = [];};
            "Ctrl+Alt+Q" = {action.quit = [];};
            "Mod+Q" = {
              repeat = false;
              action.close-window = [];
            };
            "Mod+T" = {
              repeat = false;
              action.spawn = terminal;
            };
            "Mod+B" = {
              repeat = false;
              action.spawn = browser;
            };
            "Mod+D" = {
              repeat = false;
              action.spawn = launcher;
            };

            "Mod+H" = {action.focus-column-left = [];};
            "Mod+J" = {action.focus-window-down = [];};
            "Mod+K" = {action.focus-window-up = [];};
            "Mod+L" = {action.focus-column-right = [];};
            "Mod+Ctrl+H" = {action.move-column-left = [];};
            "Mod+Ctrl+J" = {action.move-window-down = [];};
            "Mod+Ctrl+K" = {action.move-window-up = [];};
            "Mod+Ctrl+L" = {action.move-column-right = [];};
            "Mod+Shift+H" = {action.focus-monitor-left = [];};
            "Mod+Shift+J" = {action.focus-monitor-down = [];};
            "Mod+Shift+K" = {action.focus-monitor-up = [];};
            "Mod+Shift+L" = {action.focus-monitor-right = [];};
            "Mod+Shift+Ctrl+H" = {action.move-column-to-monitor-left = [];};
            "Mod+Shift+Ctrl+J" = {action.move-column-to-monitor-down = [];};
            "Mod+Shift+Ctrl+K" = {action.move-column-to-monitor-up = [];};
            "Mod+Shift+Ctrl+L" = {action.move-column-to-monitor-right = [];};

            "Mod+U" = {action.focus-workspace-down = [];};
            "Mod+I" = {action.focus-workspace-up = [];};
            "Mod+Ctrl+U" = {action.move-column-to-workspace-down = [];};
            "Mod+Ctrl+I" = {action.move-column-to-workspace-up = [];};
            "Mod+Shift+U" = {action.move-workspace-down = [];};
            "Mod+Shift+I" = {action.move-workspace-up = [];};

            "Mod+Comma" = {action.consume-window-into-column = [];};
            "Mod+Period" = {action.expel-window-from-column = [];};
            "Mod+BracketLeft" = {action.consume-or-expel-window-left = [];};
            "Mod+BracketRight" = {action.consume-or-expel-window-right = [];};

            "Mod+F" = {action.maximize-column = [];};
            "Mod+Ctrl+F" = {action.expand-column-to-available-width = [];};
            "Mod+Shift+F" = {action.fullscreen-window = [];};

            "Mod+r" = {action.switch-preset-column-width = [];};
            "Mod+Minus" = {action.set-column-width = "-10%";};
            "Mod+Equal" = {action.set-column-width = "+10%";};
            "Mod+Shift+Minus" = {action.set-window-height = "-10%";};
            "Mod+Shift+Equal" = {action.set-window-height = "+10%";};

            "Mod+V" = {action.toggle-window-floating = [];};
            "Mod+W" = {action.toggle-column-tabbed-display = [];};

            "Mod+S" = {action.screenshot = {show-pointer = false;};};
            "Mod+Shift+S" = {action.screenshot-screen = {show-pointer = false;};};
          };
        };
      };
    };
  }
