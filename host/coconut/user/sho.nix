{
  hostName,
  userName,
}: {
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../../module/home/common.nix
    ../../../module/home/common-wayland.nix
    ../../../module/home/hyprland.nix
    ../../../module/home/niri.nix

    ../../../module/home/alacritty.nix
    ../../../module/home/firefox.nix
    ../../../module/home/obsidian.nix
    ../../../module/home/discord.nix
    ../../../module/home/udiskie.nix
    ../../../module/home/ai.nix

    ## Installer not placed in repository. Place&Install manually!
    # ../../../module/home/mathematica.nix
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
}
