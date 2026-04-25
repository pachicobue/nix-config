{delib, ...}:
delib.module {
  name = "zathura";
  options = delib.singleEnableOption false;
  home.ifEnabled = {
    programs.zathura.enable = true;
  };
}
