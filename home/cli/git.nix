{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "pachicobue";
    userEmail = "tigerssho@gmail.com";
    difftastic.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  programs.gh = {
    enable = true;
    extensions = [
      pkgs.gh-dash
      pkgs.gh-markdown-preview
    ];
  };
}
