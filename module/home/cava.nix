{ delib, ... }:
delib.module {
  name = "cava";
  options.cava.enable = delib.boolOption false;
  home.ifEnabled.programs.cava.enable = true;
}
