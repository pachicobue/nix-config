{delib, ...}:
delib.module {
  name = "rustdesk";
  options = delib.singleEnableOption false;

  myconfig.ifEnabled = {
    programs.rustdesk.enable = true;
  };
}
