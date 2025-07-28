{ flake, ... }:
{
  imports = [
    flake.modules.home.common
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
}
