{ delib, ... }:
delib.module {
  name = "home.carapace";
  home.always.programs.carapace = {
    enable = true;
    enableZshIntegration = true;
  };
}
