{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./container.nix

    ../../module/nixos/common.nix
    ../../module/nixos/openssh.nix
    # ../../module/nixos/netbird-client.nix
    ../../module/nixos/tailscale.nix
    ../../module/nixos/wakeonlan.nix
  ];

  networking.nameservers = ["127.0.0.1"];

  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible = {
        enable = true;
        configurationLimit = 3;
      };
      timeout = 3;
    };
  };

  # Reboot per day using systemd timer
  systemd.timers.daily-reboot = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 08:00:00";
      Persistent = true;
      Unit = "daily-reboot.service";
    };
  };

  systemd.services.daily-reboot = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl reboot";
    };
    description = "Daily system reboot at 8:00 AM";
  };
}
