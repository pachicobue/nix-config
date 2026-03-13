{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  terminal = "alacritty";

  niri-focus-app = pkgs.writeScriptBin "niri-focus-app" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    if [ $# -eq 0 ]; then
      echo "Usage: niri-focus-app <app-id>"
      exit 1
    fi

    APP_ID="$1"

    # Get window list and focus the first window with matching app_id
    WINDOW_ID=$(${pkgs.niri}/bin/niri msg --json windows | \
      ${pkgs.jq}/bin/jq -r ".[] | select(.app_id == \"$APP_ID\") | .id" | \
      head -n1)

    if [ -n "$WINDOW_ID" ]; then
      ${pkgs.niri}/bin/niri msg action focus-window --id "$WINDOW_ID"
    else
      echo "No window found with app-id: $APP_ID" >&2
      exit 1
    fi
  '';
in {
  imports = [
    inputs.niri-flake.homeModules.niri
    ../alacritty.nix
    ../fuzzel.nix
    ../jq.nix
    ../noctalia-shell.nix
  ];
  home.packages = [
    niri-focus-app
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
      hotkey-overlay.skip-at-startup = true;
      cursor = {
        hide-when-typing = true;
      };

      input = {
        warp-mouse-to-focus.enable = true;
        focus-follows-mouse = {
          enable = true;
        };
        touchpad = {
          dwt = true;
        };
      };

      spawn-at-startup = [
        {command = ["fcitx" "-r"];}
        {command = ["noctalia-shell"];}
        {command = ["firefox-beta"];}
        {command = [terminal];}
        {command = [terminal];}
      ];

      workspaces = {
        "1other" = {};
        "2terminal" = {};
        "3browser" = {};
        "4gaming" = {};
      };

      layout = {
        gaps = 8;
        always-center-single-column = true;
        center-focused-column = "never";
        default-column-width = {proportion = 1. / 2.;};
        preset-column-widths = [
          {proportion = 1. / 3.;}
          {proportion = 1. / 2.;}
          {proportion = 2. / 3.;}
        ];
        background-color = "transparent";
      };

      window-rules = [
        {
          # For noctalia-shell
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
              app-id = "Alacritty";
              at-startup = true;
            }
          ];
          open-on-workspace = "2terminal";
        }
        {
          matches = [
            {app-id = "firefox-beta";}
          ];
          open-on-workspace = "3browser";
        }
        {
          matches = [
            {app-id = "steam";}
          ];
          open-on-workspace = "4gaming";
        }
        {
          matches = [
            {app-id = "steam_app_default";}
          ];
          open-on-workspace = "4gaming";
        }
      ];

      layer-rules = [
        {
          # For noctalia-shell
          matches = [
            {namespace = "^noctalia-overview*";}
          ];
          place-within-backdrop = true;
        }
      ];

      overview = {
        workspace-shadow = {
          enable = true;
        };
      };

      debug = {
        # For noctalia-shell
        honor-xdg-activation-with-invalid-serial = true;
      };

      binds = with config.lib.niri.actions; {
        "Mod+Shift+Slash" = {action = show-hotkey-overlay;};

        "Mod+Q" = {
          repeat = false;
          action = close-window;
        };

        "Mod+T" = {
          repeat = false;
          action.spawn = terminal;
        };
        "Mod+D" = {
          repeat = false;
          action.spawn = ["noctalia-shell" "ipc" "call" "launcher" "toggle"];
        };
        "Mod+S" = {
          repeat = false;
          action.spawn = ["noctalia-shell" "ipc" "call" "controlCenter" "toggle"];
        };
        "Mod+E" = {
          repeat = false;
          action.spawn = ["noctalia-shell" "ipc" "call" "sessionMenu" "toggle"];
        };
        "Mod+C" = {
          repeat = false;
          action.spawn = ["noctalia-shell" "ipc" "call" "calendar" "toggle"];
        };

        "Mod+H" = {action = focus-column-left;};
        "Mod+J" = {action = focus-window-down;};
        "Mod+K" = {action = focus-window-up;};
        "Mod+L" = {action = focus-column-right;};
        "Mod+Ctrl+H" = {action = move-column-left;};
        "Mod+Ctrl+J" = {action = move-window-down;};
        "Mod+Ctrl+K" = {action = move-window-up;};
        "Mod+Ctrl+L" = {action = move-column-right;};
        "Mod+Shift+H" = {action = focus-monitor-left;};
        "Mod+Shift+J" = {action = focus-monitor-down;};
        "Mod+Shift+K" = {action = focus-monitor-up;};
        "Mod+Shift+L" = {action = focus-monitor-right;};
        "Mod+Shift+Ctrl+H" = {action = move-column-to-monitor-left;};
        "Mod+Shift+Ctrl+J" = {action = move-column-to-monitor-down;};
        "Mod+Shift+Ctrl+K" = {action = move-column-to-monitor-up;};
        "Mod+Shift+Ctrl+L" = {action = move-column-to-monitor-right;};

        "Mod+U" = {action = focus-workspace-down;};
        "Mod+I" = {action = focus-workspace-up;};
        "Mod+Ctrl+U" = {action = move-column-to-workspace-down;};
        "Mod+Ctrl+I" = {action = move-column-to-workspace-up;};
        "Mod+Shift+U" = {action = move-workspace-down;};
        "Mod+Shift+I" = {action = move-workspace-up;};

        "Mod+1" = {action.focus-workspace = "1other";};
        "Mod+2" = {action.focus-workspace = "2terminal";};
        "Mod+3" = {action.focus-workspace = "3browser";};
        "Mod+4" = {action.focus-workspace = "4gaming";};

        "Mod+Comma" = {action = consume-window-into-column;};
        "Mod+Period" = {action = expel-window-from-column;};
        "Mod+BracketLeft" = {action = consume-or-expel-window-left;};
        "Mod+BracketRight" = {action = consume-or-expel-window-right;};

        "Mod+F" = {action = maximize-column;};
        "Mod+Ctrl+F" = {action = expand-column-to-available-width;};
        "Mod+Shift+F" = {action = fullscreen-window;};

        "Mod+Ctrl+C" = {action = center-column;};

        "Mod+R" = {action = switch-preset-column-width;};
        "Mod+Shift+R" = {action = switch-preset-window-height;};
        "Mod+Minus" = {action = set-column-width "-10%";};
        "Mod+Equal" = {action = set-column-width "+10%";};
        "Mod+Shift+Minus" = {action = set-window-height "-10%";};
        "Mod+Shift+Equal" = {action = set-window-height "+10%";};

        "Mod+V" = {action = toggle-window-floating;};
        "Mod+W" = {action = toggle-column-tabbed-display;};

        "Ctrl+Alt+Delete" = {action = quit;};
        "Ctrl+Alt+L" = {
          action.spawn = ["noctalia-shell" "ipc" "call" "lockScreen" "lock"];
        };
      };
      screenshot-path = "~/Picture/Screenshots/%Y%m%d_%H%M%s.png";
    };
  };
}
