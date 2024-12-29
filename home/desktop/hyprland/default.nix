{ pkgs, inputs, ... }:
let
  package = inputs.hyprland.packages.${pkgs.system}.hyprland;
in
{
  imports = [
    ./config.nix
    ./keybind.nix
    ./waybar.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./mako.nix
    ./walker.nix
  ];
  wayland.windowManager.hyprland = {
    inherit package;
    enable = true;
    systemd.enable = true;
  };
  home.packages = with pkgs; [
    wleave
    wayvnc
    pavucontrol
    wl-clipboard
    hyprshade
    hyprshot
  ];
}
