{
  delib,
  host,
  lib,
  ...
}:
delib.module {
  name = "graphics";
  options = with delib;
    moduleOptions {
      enable = boolOption host.nvidiaFeatured;
    };

  nixos.ifEnabled = with lib; {
    services.xserver.videoDrivers = optional host.nvidiaFeatured "nvidia";
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    hardware.nvidia = mkIf host.nvidiaFeatured {
      open = true;
      nvidiaSettings = false;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
    };
  };
}
