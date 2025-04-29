{ pkgs, inputs, ... }:
let
  package = inputs.hyprland.packages.${pkgs.system}.hyprland;
in
{
  imports = [
    ./config.nix
    ./keybind.nix
    ./waybar.nix
    ./hyprpaper.nix
    ./mako.nix
    ./fuzzel.nix
  ];
  wayland.windowManager.hyprland = {
    inherit package;
    enable = true;
    systemd.enable = true;
  };
  home.packages = with pkgs; [
    wleave
    pavucontrol
    hyprshade
    hyprshot
  ];
}
