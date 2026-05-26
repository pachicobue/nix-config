{delib, ...}:
delib.module {
  name = "programs.zsh";
  options = delib.singleEnableOption false;

  home.ifEnabled = {myconfig, ...}: {
    home.shell.enableZshIntegration = true;
    programs.zsh = {
      enable = true;
      defaultKeymap = "emacs";
      dotDir = "${myconfig.xdg.configHome}/zsh";
      shellAliases = {
        e = "$EDITOR";
      };
      autocd = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      history = {
        ignoreAllDups = true;
      };
      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
}
