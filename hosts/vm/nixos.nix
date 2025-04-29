args: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/core.nix
    # ../../modules/audio.nix
    # ../../modules/tuigreet.nix
    ../../modules/clock.nix
    ../../modules/fonts.nix
    ../../modules/fcitx5.nix
    ../../modules/network.nix
    # ../../modules/nvidia.nix
    # ../../modules/steam.nix
    # ../../modules/qemu.nix
    # ../../modules/fprintd.nix
  ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  users.users."${args.username}" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "input"
      "uinput"
    ];
  };

  # Don't touch this
  system.stateVersion = "24.05";
}
