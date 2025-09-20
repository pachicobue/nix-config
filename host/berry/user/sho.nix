{
  hostname,
  username,
}: {
  inputs,
  pkgs,
  ...
}: {
  # Home Manager modules
  imports = [
    ../../../module/home/common.nix
    ../../../module/home/common-wayland.nix
    ../../../module/home/hyprland.nix

    ../../../module/home/alacritty.nix
    ../../../module/home/firefox.nix
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
}
