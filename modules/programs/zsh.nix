{delib, ...}:
delib.module {
  name = "programs.zsh";
  options = delib.singleEnableOption true;

  nixos.ifEnabled = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
    };
  };

  home.ifEnabled = {myconfig, ...}: {
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
