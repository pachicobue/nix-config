{ ... }:
{
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';
  services.kanata = {
    enable = true;
    keyboards.HHKB = {
      devices = [ "/dev/input/by-id/usb-PFU_Limited_HHKB-Classic-event-kbd" ];
      configFile = ./kanata_cfgs/HHKB.kbd;
    };
  };
}
