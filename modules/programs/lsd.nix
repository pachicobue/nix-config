{delib, ...}:
delib.module {
  name = "programs.lsd";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.lsd = {
      enable = true;
    };
  };
}
