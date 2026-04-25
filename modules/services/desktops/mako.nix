{delib, ...}:
delib.module {
  name = "mako";
  options = delib.singleEnableOption false;
  home.ifEnabled = {
    services.mako = {
      enable = true;
      settings = {
        default-timeout = 5000;
      };
    };
  };
}
