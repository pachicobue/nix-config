{ pkgs, ... }:
{
  imports = [
    ./kitty.nix
    ./foot.nix
    ./alacritty.nix
    ./firefox.nix
  ];
  home.packages = with pkgs; [
    webcord
  ];
}
