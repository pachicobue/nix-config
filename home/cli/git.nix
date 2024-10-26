{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "pachicobue";
    userEmail = "tigerssho@gmail.com";
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  programs.gh = {
    enable = true;
    package = pkgs.gh;
  };
}
