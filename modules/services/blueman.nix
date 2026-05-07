{delib, ...}:
delib.module {
  name = "services.blueman";
  options = delib.singleEnableOption false;
  nixos.ifEnabled = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman = {
      enable = true;
      withApplet = true;
    };
  };
}
