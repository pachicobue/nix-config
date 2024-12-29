{ pkgs, ... }:
{
  imports = [
    ./kitty.nix
    ./foot.nix
    ./alacritty.nix
    ./emacs
    ./firefox.nix
  ];
  home.packages = with pkgs; [
    webcord
  ];
}
