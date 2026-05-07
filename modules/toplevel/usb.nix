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
  };

  home.ifEnabled = {cfg, ...}: {
    services.udiskie.enable = cfg.enableStorage;
    home.packages = with pkgs; [
      usbutils
    ];
  };
}
