{ pkgs, ... }:
{
  home.stateVersion = "25.05";
  imports = [
    ./common/atuin.nix
    ./common/bat.nix
    ./common/bottom.nix
    ./common/carapace.nix
    ./common/fastfetch.nix
    ./common/fd.nix
    ./common/fzf.nix
    ./common/git.nix
    ./common/helix.nix
    ./common/pueue.nix
    ./common/ripgrep.nix
    ./common/starship.nix
    ./common/zathura.nix
    ./common/zsh.nix
    ./common/zoxide.nix
  ];
  home.packages = with pkgs; [
    procs
    scooter
    ouch
  ];
}
