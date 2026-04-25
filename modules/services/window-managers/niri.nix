{
  delib,
  host,
  pkgs,
  lib,
  ...
}: let
  niriAction = cmd: ["niri" "msg" "action"] ++ (lib.splitString " " cmd);
in
  delib.module {
    name = "services.wayland.windowManager.niri";
    options = delib.singleEnableOption false;

    nixos.ifEnabled = {
      services.displayManager.sessionPackages = [pkgs.niri-stable];
    };
    home.ifEnabled = {myconfig, ...}: let
      inherit (myconfig.commands.default) browser terminal launcher;
      inherit (myconfig.commands) shouldAutostart;
    in {
      assertions = [
        {
          assertion = host.waylandFeatured;
          message = "[niri] Need 'wayland' feature.";
        }
      ];

      # Authentication agentは固定(こだわりなし)
      services.hyprpolkitagent.enable = true;

      programs.niri = {
        enable = true;
        package = pkgs.niri-stable;
        settings = {
          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
          hotkey-overlay.skip-at-startup = true;
          cursor = {hide-when-typing = true;};
          input = {
            warp-mouse-to-focus.enable = true;
            focus-follows-mouse.enable = true;
            touchpad.dwt = true;
          };
          spawn-at-startup =
            [
              {command = browser;}
              {command = terminal;}
              {command = niriAction "toggle-column-tabbed-display";}
              {command = terminal;}
              {command = niriAction "consume-window-into-column";}
            ]
            ++ (map (c: {command = c;}) shouldAutostart);
          workspaces = {
            "1default" = {};
            "2work" = {};
            "3gaming" = {};
          };
          layout = {
            gaps = 8;
            always-center-single-column = true;
            center-focused-column = "never";
            background-color = "transparent";
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
            }
            {
              matches = [
                {
                  app-id = terminal;
                  at-startup = true;
                }
              ];
              open-on-workspace = "2work";
            }
            {
              matches = [
                {
                  app-id = browser;
                  at-startup = true;
                }
              ];
              open-on-workspace = "2work";
            }
            {
              matches = [{app-id = "steam";}];
              open-on-workspace = "3gaming";
            }
            {
              matches = [{app-id = "steam_app_default";}];
              open-on-workspace = "3gaming";
            }
          ];

          layer-rules = [
            {
              matches = [{namespace = "^noctalia-overview*";}];
              place-within-backdrop = true;
            }
          ];
          overview.workspace-shadow.enable = true;
          debug.honor-xdg-activation-with-invalid-serial = true;
          screenshot-path = "~/Picture/Screenshots/%Y%m%d_%H%M%s.png";

          binds = {
            "Mod+Shift+Slash" = {action.show-hotkey-overlay = [];};
            "Ctrl+Alt+Delete" = {action.quit = [];};
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
              action.span = launcher;
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

            "Mod+1" = {action.focus-workspace = "1default";};
            "Mod+2" = {action.focus-workspace = "2work";};
            "Mod+3" = {action.focus-workspace = "3gaming";};

            "Mod+Comma" = {action.consume-window-into-column = [];};
            "Mod+Period" = {action.expel-window-from-column = [];};
            "Mod+BracketLeft" = {action.consume-or-expel-window-left = [];};
            "Mod+BracketRight" = {action.consume-or-expel-window-right = [];};

            "Mod+F" = {action.maximize-column = [];};
            "Mod+Ctrl+F" = {action.expand-column-to-available-width = [];};
            "Mod+Shift+F" = {action.fullscreen-window = [];};

            "Mod+Minus" = {action.set-column-width = "-10%";};
            "Mod+Equal" = {action.set-column-width = "+10%";};
            "Mod+Shift+Minus" = {action.set-window-height = "-10%";};
            "Mod+Shift+Equal" = {action.set-window-height = "+10%";};

            "Mod+V" = {action.toggle-window-floating = [];};
            "Mod+W" = {action.toggle-column-tabbed-display = [];};
          };
        };
      };
    };
  }
