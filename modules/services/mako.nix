{delib, ...}:
delib.module {
  name = "services.mako";
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
