{ delib, ... }:
delib.module {
  name = "ghostty";
  options.ghostty.enable = delib.boolOption false;
  home.ifEnabled.programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      window-padding-x = 10;
      window-padding-y = 5;
      window-padding-balance = true;
    };
  };
}
