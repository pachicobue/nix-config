{ delib, ... }:
delib.module {
  name = "nixos.dbus";
  nixos.always.services.dbus.implementation = "broker";
}
