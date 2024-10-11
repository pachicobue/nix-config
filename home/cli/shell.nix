{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    defaultKeymap = "emacs";
    dotDir = ".config.zsh";
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      rm = "rm -i";
      cp = "cp -i";
      ll = "ls -l";
      la = "ls -a";
    };
  };
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
