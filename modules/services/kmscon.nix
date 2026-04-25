{delib, ...}:
delib.module {
  name = "services.kmscon";
  options = delib.singleEnableOption true;
  nixos.ifEnabled = {
    services.kmscon.enable = true;
  };
}
