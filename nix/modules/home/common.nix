{
  pkgs,
  inputs,
  ...
}:
{
  home.stateVersion = "25.05";
  home.shellAliases = {
    e = "$EDITOR";
    rm = "rm -i";
    cp = "cp -i";
  };

  imports = [
    inputs.catppuccin.homeModules.catppuccin

    ./common/atuin.nix
    ./common/bat.nix
    ./common/btop.nix
    ./common/bottom.nix
    ./common/carapace.nix
    ./common/fastfetch.nix
    ./common/fd.nix
    ./common/git.nix
    ./common/helix.nix
    ./common/lsd.nix
    ./common/pueue.nix
    ./common/ripgrep.nix
    ./common/skim.nix
    ./common/starship.nix
    ./common/zathura.nix
    ./common/zsh.nix
    ./common/zoxide.nix
  ];
  catppuccin = {
    enable = false;
    flavor = "mocha";
    accent = "pink";
  };
  home.packages = with pkgs; [
    rip2
    procs
    scooter
    ouch
    manix
  ];
}
