{ pkgs, ... }:
{
  imports = [
    ./emacs
    ./firefox.nix
    ./kitty.nix
    ./mangohud.nix
  ];
  home.packages = with pkgs; [
    webcord
  ];
}
