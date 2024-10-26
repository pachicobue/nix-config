{ pkgs, inputs, ... }:
let
  package = inputs.hyprland.packages.${pkgs.system}.hyprland;
in
{
  imports = [
    ./config.nix
    ./keybind.nix
    ./waybar.nix
    ./mako.nix
  ];
  wayland.windowManager.hyprland = {
    inherit package;
    enable = true;
    systemd.enable = true;
  };
  home.packages = with pkgs; [
    hypridle
    walker
    wleave
    brightnessctl
    pavucontrol
    wl-clipboard
    cliphist
  ];
}
