{delib, ...}:
delib.module {
  name = "services.login-managers.lemurs";
  options = delib.singleEnableOption false;
  nixos.ifEnabled = {
    services.displayManager.lemurs.enable = true;
  };
}
