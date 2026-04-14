{ delib, ... }:
delib.module {
  name = "home.lsd";
  home.always.programs.lsd = {
    enable = true;
    enableZshIntegration = true;
  };
}
