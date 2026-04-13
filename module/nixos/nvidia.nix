{ delib, ... }:
delib.module {
  name = "nvidia";
  options.nvidia.enable = delib.boolOption false;
  nixos.ifEnabled = {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    hardware.nvidia = {
      open = true;
      nvidiaSettings = false;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
    };
    hardware.nvidia-container-toolkit.enable = true;
  };
}
