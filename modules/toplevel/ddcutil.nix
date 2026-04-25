{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "ddc";
  options = delib.singleEnableOption host.isDesktop;
  nixos.ifEnabled = {
    hardware.i2c.enable = true;
    environment.systemPackages = [pkgs.ddcutil];
  };
}
