{delib, ...}:
delib.module {
  name = "programs.ripgrep";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs = {
      ripgrep.enable = true;
      ripgrep-all.enable = true;
    };
  };
}
