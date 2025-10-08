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
    ./mako.nix
    ./alacritty.nix
    ./fuzzel.nix
    # ./anyrun.nix
  ];
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
      binds = with config.lib.niri.actions; {
        "Mod+Shift+Slash" = {
          repeat = false;
          action = show-hotkey-overlay;
        };
        "Mod+T" = {
          repeat = false;
          action = spawn terminal;
        };
        "Mod+Space" = {
          repeat = false;
          action = spawn launcher;
        };
        "Mod+L" = {
          repeat = false;
        };
        "Mod+H" = {action = focus-column-left;};
        "Mod+J" = {action = focus-window-down;};
        "Mod+K" = {action = focus-window-up;};
        "Mod+L" = {action = focus-column-right;};
        "Mod+Shift+H" = {action = move-column-left;};
        "Mod+Shift+J" = {action = move-window-down;};
        "Mod+Shift+K" = {action = move-window-up;};
        "Mod+Shift+L" = {action = move-column-right;};
        "Mod+u" = {action = focus-workspace-down;};
        "Mod+i" = {action = focus-workspace-up;};
        "Mod+Shift+u" = {action = move-column-to-workspace-down;};
        "Mod+Shift+i" = {action = move-column-to-workspace-up;};
        "Alt+Tab" = {action = spawn "niri-switch";};
      };
      screenshot-path = "~/Picture/Screenshots/%Y%m%d-%H%M%s.png";
      spawn-at-startup = [
        {argv = ["niri-switch-daemon"];}
      ];
    };
  };
  programs.niriswitcher = {
    enable = true;
  };
  stylix.targets.niri.enable = true;
}
