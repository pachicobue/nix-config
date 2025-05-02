{ pkgs, inputs, ... }:
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
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  home.packages = with pkgs; [
    wleave
    pavucontrol
    hyprshot
  ];
}
