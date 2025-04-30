{ pkgs, ... }:
{
  imports = [
    ./atuin.nix
    ./bat.nix
    ./bottom.nix
    ./carapace.nix
    ./direnv.nix
    ./fastfetch.nix
    ./fd.nix
    ./fzf.nix
    ./git.nix
    ./helix.nix
    ./lazygit.nix
    ./ripgrep.nix
    ./starship.nix
    ./tmux.nix
    ./yazi.nix
    ./zathura.nix
    ./zsh.nix
    ./zoxide.nix

    ./zellij
    ./smartcat
  ];
  home.packages = with pkgs; [
    pueue
    du-dust
    procs
    xh
    scooter
    ouch
  ];
}
