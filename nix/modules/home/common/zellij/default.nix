{ ... }:
{
  home.file = {
    ".config/zellij/config.kdl" = {
      source = ./config.kdl;
    };
    ".config/zellij/layouts/float.kdl" = {
      source = ./layouts/float.kdl;
    };
  };
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };
}
