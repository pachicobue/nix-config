{pkgs, ...}: {
  services.udisks2.enable = true;
  environment.systemPackages = [
    pkgs.usbutils
  ];

  # Avoid MagicTrackpad-2 problem
  systemd.services.reset-magic-trackpad = {
    description = "Reset Magic Trackpad after suspend";
    after = ["suspend.target" "hibernate.target" "hybrid-sleep.target"];
    wantedBy = ["suspend.target" "hibernate.target" "hybrid-sleep.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.kmod}/bin/modprobe -r hid_magicmouse && sleep 0.5 && ${pkgs.kmod}/bin/modprobe hid_magicmouse'";
    };
  };
}
