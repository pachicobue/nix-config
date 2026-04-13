{ delib, ... }:
delib.module {
  name = "zathura";
  options.zathura.enable = delib.boolOption false;
  home.ifEnabled.programs.zathura.enable = true;
}
