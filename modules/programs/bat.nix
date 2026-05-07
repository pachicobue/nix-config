{delib, ...}:
delib.module {
  name = "programs.bat";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.bat.enable = true;
  };
}
