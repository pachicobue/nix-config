{ delib, ... }:
delib.module {
  name = "wlogout";
  options.wlogout.enable = delib.boolOption false;
  home.ifEnabled.programs.wlogout.enable = true;
}
