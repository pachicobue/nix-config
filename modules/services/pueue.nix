{delib, ...}:
delib.module {
  name = "services.pueue";
  options = delib.singleEnableOption true;
  home.ifEnabled = {
    services.pueue.enable = true;
  };
}
