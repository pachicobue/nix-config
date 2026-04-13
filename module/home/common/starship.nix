{ delib, ... }:
delib.module {
  name = "home.starship";
  home.always.programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
