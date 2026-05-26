{delib, ...}:
delib.module {
  name = "services.blueman";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      withApplet = boolOption false;
    };
  nixos.ifEnabled = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman = {
      enable = true;
    };
  };
  home.ifEnabled = {cfg, ...}: {
    services.blueman-applet.enable = cfg.withApplet;
  };
}
