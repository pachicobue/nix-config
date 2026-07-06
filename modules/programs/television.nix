{delib, ...}:
delib.module {
  name = "programs.television";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.television = {
      enable = true;
    };
  };
}
