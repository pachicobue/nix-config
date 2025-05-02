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
  };
}
