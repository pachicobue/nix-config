{ pkgs, ... }:
{
  imports = [
    ./atuin.nix
    ./bat.nix
    ./bottom.nix
    ./direnv.nix
    ./fastfetch.nix
    ./fd.nix
    ./fzf.nix
    ./git.nix
    ./helix.nix
    ./lazygit.nix
    ./ripgrep.nix
    ./starship.nix
    ./zsh.nix
    ./zoxide.nix

    ./nushell
    ./zellij
    ./smartcat
  ];
  home.packages = with pkgs; [
    pueue
    glow
    wl-clipboard
    du-dust
    procs
    xh
  ];
}
