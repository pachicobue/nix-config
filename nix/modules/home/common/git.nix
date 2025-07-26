{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
      userName = "pachicobue";
      userEmail = "12893287+pachicobue@users.noreply.github.com";
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

    gitui = {
      enable = true;
    };
  };
  catppuccin = {
    delta = {
      enable = true;
    };
    gitui = {
      enable = true;
    };
    gh-dash = {
      enable = true;
    };
  };
}
