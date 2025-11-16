{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  terminal = "alacritty";
  launcher = "fuzzel";
in {
  imports = [
    inputs.niri-flake.homeModules.niri
    inputs.niri-flake.homeModules.stylix
    ./alacritty.nix
    ./fuzzel.nix
  ];
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
      binds = with config.lib.niri.actions; {
        "Mod+Shift+Slash" = {action = show-hotkey-overlay;};

        "Mod+T" = {action.spawn = terminal;};
        "Mod+D" = {action.spawn = launcher;};

        "Mod+Q" = {action = close-window;};

        "Mod+Left" = {action = focus-column-left;};
        "Mod+Down" = {action = focus-window-down;};
        "Mod+Up" = {action = focus-window-up;};
        "Mod+Right" = {action = focus-column-right;};
        "Mod+H" = {action = focus-column-left;};
        "Mod+J" = {action = focus-window-down;};
        "Mod+K" = {action = focus-window-up;};
        "Mod+L" = {action = focus-column-right;};

        "Mod+Ctrl+Left" = {action = move-column-left;};
        "Mod+Ctrl+Down" = {action = move-window-down;};
        "Mod+Ctrl+Up" = {action = move-window-up;};
        "Mod+Ctrl+Right" = {action = move-column-right;};
        "Mod+Ctrl+H" = {action = move-column-left;};
        "Mod+Ctrl+J" = {action = move-window-down;};
        "Mod+Ctrl+K" = {action = move-window-up;};
        "Mod+Ctrl+L" = {action = move-column-right;};

        "Mod+Ctrl+Home" = {action = move-column-to-first;};
        "Mod+Ctrl+End" = {action = move-column-to-last;};
        "Mod+Home" = {action = focus-column-first;};
        "Mod+End" = {action = focus-column-last;};

        "Mod+Shift+Left" = {action = focus-monitor-left;};
        "Mod+Shift+Down" = {action = focus-monitor-down;};
        "Mod+Shift+Up" = {action = focus-monitor-up;};
        "Mod+Shift+Right" = {action = focus-monitor-right;};
        "Mod+Shift+H" = {action = focus-monitor-left;};
        "Mod+Shift+J" = {action = focus-monitor-down;};
        "Mod+Shift+K" = {action = focus-monitor-up;};
        "Mod+Shift+L" = {action = focus-monitor-right;};

        "Mod+Shift+Ctrl+Left" = {action = move-column-to-monitor-left;};
        "Mod+Shift+Ctrl+Down" = {action = move-column-to-monitor-down;};
        "Mod+Shift+Ctrl+Up" = {action = move-column-to-monitor-up;};
        "Mod+Shift+Ctrl+Right" = {action = move-column-to-monitor-right;};
        "Mod+Shift+Ctrl+H" = {action = move-column-to-monitor-left;};
        "Mod+Shift+Ctrl+J" = {action = move-column-to-monitor-down;};
        "Mod+Shift+Ctrl+K" = {action = move-column-to-monitor-up;};
        "Mod+Shift+Ctrl+L" = {action = move-column-to-monitor-right;};

        "Mod+Page_Down" = {action = focus-workspace-down;};
        "Mod+Page_Up" = {action = focus-workspace-up;};
        "Mod+U" = {action = focus-workspace-down;};
        "Mod+I" = {action = focus-workspace-up;};

        "Mod+Ctrl+Page_Down" = {action = move-column-to-workspace-down;};
        "Mod+Ctrl+Page_Up" = {action = move-column-to-workspace-up;};
        "Mod+Ctrl+U" = {action = move-column-to-workspace-down;};
        "Mod+Ctrl+I" = {action = move-column-to-workspace-up;};

        "Mod+Shift+Page_Down" = {action = move-workspace-down;};
        "Mod+Shift+Page_Up" = {action = move-workspace-up;};
        "Mod+Shift+U" = {action = move-workspace-down;};
        "Mod+Shift+I" = {action = move-workspace-up;};

        "Mod+Comma" = {action = consume-window-into-column;};
        "Mod+Period" = {action = expel-window-from-column;};
        "Mod+BracketLeft" = {action = consume-or-expel-window-left;};
        "Mod+BracketRight" = {action = consume-or-expel-window-right;};

        "Mod+R" = {action = switch-preset-column-width;};
        "Mod+F" = {action = maximize-column;};
        "Mod+Shift+F" = {action = fullscreen-window;};
        "Mod+C" = {action = center-column;};

        "Mod+Minus" = {action = set-column-width "-10%";};
        "Mod+Equal" = {action = set-column-width "+10%";};

        "Mod+Shift+Minus" = {action = set-window-height "-10%";};
        "Mod+Shift+Equal" = {action = set-window-height "+10%";};

        # "Print" = {action = screenshot;};
        # "Ctrl+Print" = {action = screenshot-screen;};
        # "Alt+Print" = {action = screenshot-window;};

        "Mod+Shift+E" = {action = quit;};
        "Ctrl+Alt+Delete" = {action = quit;};
      };
      screenshot-path = "~/Picture/Screenshots/%Y%m%d-%H%M%s.png";
    };
  };
  programs.niriswitcher = {
    enable = true;
  };
  stylix.targets.niri.enable = true;
}
