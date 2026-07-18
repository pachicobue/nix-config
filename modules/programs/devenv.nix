{delib, ...}:
delib.module {
  name = "programs.devenv";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.devenv = {
      enable = true;
    };
  };
}
