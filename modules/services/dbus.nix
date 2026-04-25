{delib, ...}:
delib.module {
  name = "services.dbus";
  options = delib.singleEnableOption true;
  nixos.ifEnabled = {
    services.dbus.implementation = "broker";
  };
}
