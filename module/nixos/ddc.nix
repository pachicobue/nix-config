{ delib, pkgs, ... }:
delib.module {
  name = "ddc";
  options.ddc.enable = delib.boolOption false;
  nixos.ifEnabled = {
    hardware.i2c.enable = true;
    environment.systemPackages = [ pkgs.ddcutil ];
  };
}
