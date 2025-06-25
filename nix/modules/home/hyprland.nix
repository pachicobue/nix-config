{ pkgs, ... }:
{
  imports = [
    ./hyprland/config.nix
    ./hyprland/keybind.nix

    ./hyprland/fuzzel.nix
    ./hyprland/hyprpaper.nix
    ./hyprland/hyprpolkitagent.nix
    ./hyprland/hyprsunset.nix
    ./hyprland/mako.nix
    ./hyprland/waybar.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
  };
  home.packages = with pkgs; [
    wleave
    pavucontrol
    hyprshot
  ];
}
