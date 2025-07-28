{ ... }:
{
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    completionInit = ''
      autoload -U compinit && compinit
      zstyle ':completion:*:default' menu true select
    '';
    history = {
      ignoreAllDups = true;
    };
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
  };
  catppuccin.zsh-syntax-highlighting = {
    enable = true;
  };
}
