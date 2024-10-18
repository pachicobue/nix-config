{ pkgs, ... }:
{
  imports = [
    ./emacs.nix
    ./firefox.nix
    ./term.nix
    ./theme.nix
  ];
  home.packages = with pkgs; [
    webcord
  ];
}
