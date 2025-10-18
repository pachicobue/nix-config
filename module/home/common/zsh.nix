{config, ...}: {
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    dotDir = "${config.home.homeDirectory}/.config/zsh";
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
