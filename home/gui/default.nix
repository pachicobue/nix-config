{ pkgs, ... }:
{
  imports = [
    ./kitty.nix
    ./foot.nix
    ./alacritty.nix
    ./firefox.nix
    ./obsidian.nix
    ./zathura.nix
    ./zed.nix

    ./mathematica
    ./document
  ];
  home.packages = with pkgs; [
    webcord
  ];
}
