{ ... }:
{
  programs.zsh = {
    enable = true;

    defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    history = {
      ignoreAllDups = true;
    };
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      e = "hx";
      g = "lazygit";
      rm = "rm -i";
      cp = "cp -i";
      ll = "ls -l";
      la = "ls -a";
    };
  };
}
