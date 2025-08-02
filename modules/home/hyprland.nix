{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hyprland/config.nix
    ./hyprland/keybind.nix

    ./hyprland/fuzzel.nix
    ./hyprland/hyprpolkitagent.nix
    ./hyprland/hyprsunset.nix
    ./hyprland/hyprpanel.nix
  ];
  catppuccin = {
    hyprland = {
      enable = true;
    };
    cursors = {
      enable = true;
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];
  };
  services.fusuma = {
    enable = true;
    settings = {
      swipe = {
        "3" = {
          left = {
            command = "hyprctl dispatch workspace +1";
          };
          right = {
            command = "hyprctl dispatch workspace -1";
          };
          down = {
            command = "hyprctl dispatch togglespecialworkspace";
          };
          up = {
            command = "hyprctl dispatch togglespecialworkspace";
          };
        };
        "4" = {
          left = {
            command = "hyprctl dispatch movetoworkspace -1";
          };
          right = {
            command = "hyprctl dispatch movetoworkspace +1";
          };
          down = {
            command = "hyprctl dispatch movetoworkspace +0";
          };
          up = {
            command = "hyprctl dispatch movetoworkspace special";
          };
        };
      };
    };
  };
  home.packages = with pkgs; [
    fusuma
    pavucontrol
    hyprshot
  ];
}
