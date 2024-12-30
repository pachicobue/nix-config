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
      (import ./gh-q.nix pkgs)
      pkgs.gh-dash
      pkgs.gh-markdown-preview
    ];
  };
}
