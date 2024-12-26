{ pkgs, ... }:
{
  imports = [
    ./emacs
    ./firefox.nix
  ];
  home.packages = with pkgs; [
    webcord
  ];
}
