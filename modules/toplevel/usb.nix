{
  delib,
  host,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "usb";
  options = with delib;
    moduleOptions {
      enable = boolOption host.usbFeatured;
      enableStorage = boolOption true;
      enableMagicTrackpadFix = boolOption host.isDesktop;
      enableXenoPlusGamepadFix = boolOption false;
    };

  nixos.ifEnabled = {cfg, ...}: {
    services.udisks2.enable = cfg.enableStorage;
    systemd.services.reset-magic-trackpad = lib.mkIf cfg.enableMagicTrackpadFix {
      description = "Reset Magic Trackpad after suspend";
      after = ["suspend.target" "hibernate.target" "hybrid-sleep.target"];
      wantedBy = ["suspend.target" "hibernate.target" "hybrid-sleep.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.kmod}/bin/modprobe -r hid_magicmouse && sleep 0.5 && ${pkgs.kmod}/bin/modprobe hid_magicmouse'";
      };
    };

    # LeadJoy Xeno Plus is a generic USB gamepad (4131:3519) that doesn't
    # autobind to the xpad driver.
    boot.kernelModules = lib.optionals cfg.enableXenoPlusGamepadFix ["xpad"];

    services.udev.extraRules = lib.optionalString cfg.enableXenoPlusGamepadFix ''
      # LeadJoy Xeno Plus — auto-bind xpad on connect
      ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="4131", ATTRS{idProduct}=="3519", RUN+="/bin/sh -c 'echo 4131 3519 > /sys/bus/usb/drivers/xpad/new_id'"
    '';
  };

  home.ifEnabled = {cfg, ...}: {
    services.udiskie.enable = cfg.enableStorage;
    home.packages = with pkgs; [
      usbutils
    ];
  };
}
