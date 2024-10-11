{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
    ./term.nix
    ./theme.nix
  ];
  home.packages = with pkgs; [
    webcord
  ];
}
