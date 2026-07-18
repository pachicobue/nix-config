{delib, ...}:
delib.module {
  name = "programs.zellij";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.zellij = {
      enable = true;
    };
  };
}
