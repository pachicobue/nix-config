{ delib, ... }:
delib.module {
  name = "bluetooth";
  options.bluetooth.enable = delib.boolOption false;
  nixos.ifEnabled = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;
  };
}
