{ pkgs, ... }:
{
  imports = [
    ./kitty.nix
    ./foot.nix
    ./alacritty.nix
    ./firefox.nix
    ./obsidian.nix
    ./zathura.nix

    ./document
  ];
  home.packages = with pkgs; [
    webcord
  ];
}
