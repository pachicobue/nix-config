{ ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    input = {
      General = {
        UserspaceHID = true;
      };
    };
  };
  services.blueman.enable = true;
}
