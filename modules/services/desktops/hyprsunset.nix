{delib, ...}:
delib.module {
  name = "services.hyprsunset";
  options = delib.singleEnableOption false;
  home.ifEnabled = {
    services.hyprsunset.enable = true;
  };
}
