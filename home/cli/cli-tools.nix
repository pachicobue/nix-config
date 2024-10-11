{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    bottom
    fd
    gitui
    gping
    neofetch
    ouch
    procs
    ripgrep
    skim
    sd
    tealdeer
    tokei
    xh
  ];
}
