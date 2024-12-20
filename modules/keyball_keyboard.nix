{ ... }:
{
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="5957", ATTRS{idProduct}=="0400", MODE="0666"
  '';
}
