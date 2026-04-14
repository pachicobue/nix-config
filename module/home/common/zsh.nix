{ delib, ... }:
delib.module {
  name = "home.zsh";
  home.always = { myconfig, ... }: {
    programs.zsh = {
      enable = true;
      defaultKeymap = "emacs";
      dotDir = "/home/${myconfig.constants.userName}/.config/zsh";
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
