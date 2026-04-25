{
  delib,
  host,
  ...
}:
delib.module {
  name = "bluetooth";
  options = delib.singleEnableOption host.isPC;
  nixos.ifEnabled = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;
  };
}
