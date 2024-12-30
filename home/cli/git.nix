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
    settings = {
      aliases = {
        cd = "ghq-cd";
      };
    };
    extensions = [
      (import ./gh-q.nix pkgs)
      (import ./gh-ghq-cd.nix pkgs)
      pkgs.gh-dash
      pkgs.gh-markdown-preview
    ];
  };
}
