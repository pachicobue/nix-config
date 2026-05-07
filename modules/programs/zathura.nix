{delib, ...}:
delib.module {
  name = "programs.zathura";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.zathura.enable = true;
  };
}
