{ delib, ... }:
delib.module {
  name = "home.zoxide";
  home.always.programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
