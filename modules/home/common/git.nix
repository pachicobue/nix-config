{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
      userName = "pachicobue";
      userEmail = "tigerssho@gmail.com";
      delta.enable = true;
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    gh = {
      enable = true;
      extensions = [
        pkgs.gh-dash
        pkgs.gh-markdown-preview
      ];
    };

    git-cliff = {
      enable = true;
    };

    lazygit = {
      enable = true;
    };
  };

}
