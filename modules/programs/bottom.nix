{delib, ...}:
delib.module {
  name = "programs.bottom";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.bottom.enable = true;
  };
}
