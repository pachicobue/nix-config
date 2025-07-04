{ flake, ... }:
{
  imports = [
    flake.modules.home.common
    flake.modules.home.common-wayland
    flake.modules.home.theme

    flake.modules.home.hyprland
    flake.modules.home.ghostty
    flake.modules.home.firefox
    flake.modules.home.obsidian
    flake.modules.home.zed
    flake.modules.home.discord
    flake.modules.home.proton-pass
    flake.modules.home.udiskie

    flake.modules.home.ai

    ## Installer not placed in repository. Place&Install manually!
    # flake.modules.home.mathematica

    # flake.modules.home.ai
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
  home.shellAliases = {
    e = "hx";
    g = "lazygit";
    rm = "rm -i";
    cp = "cp -i";
    ll = "ls -l";
    la = "ls -a";
  };
}
