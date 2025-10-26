{...}: {
  imports = [
    ./hardware-configuration.nix
    ./container.nix

    ../../module/nixos/common.nix
    ../../module/nixos/openssh.nix
    ../../module/nixos/avahi.nix
    ../../module/nixos/netbird-client.nix
    ../../module/nixos/yubikey.nix
  ];

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

  # Reboot per day
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 8 * * * root reboot now"
    ];
  };
}
