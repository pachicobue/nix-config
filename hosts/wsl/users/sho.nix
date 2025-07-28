{ flake, ... }:
{
  imports = [
    flake.modules.home.common
    flake.modules.home.common-wayland
    flake.modules.home.ai
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
}
