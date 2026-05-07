{delib, ...}:
delib.module {
  name = "programs.fd";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.fd.enable = true;
  };
}
