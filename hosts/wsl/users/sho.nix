{ flake, ... }:
{
  imports = [
    flake.modules.home.common
    flake.modules.home.common-wayland
    flake.modules.home.theme

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
