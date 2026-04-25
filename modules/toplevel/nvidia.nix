{
  delib,
  host,
  ...
}:
delib.module {
  name = "nvidia";
  options = delib.singleEnableOption host.nvidiaFeatured;
  nixos.ifEnabled = {
    services.xserver.videoDrivers = ["nvidia"];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    #TODO: Laptopでの設定
    hardware.nvidia = {
      open = true;
      nvidiaSettings = false;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
    };
  };
}
