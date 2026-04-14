{ delib, ... }:
delib.module {
  name = "fuzzel";
  options.fuzzel.enable = delib.boolOption false;
  home.ifEnabled.programs.fuzzel.enable = true;
}
