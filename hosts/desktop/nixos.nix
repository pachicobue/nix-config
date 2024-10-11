args: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/audio.nix
    ../../modules/clock.nix
    ../../modules/fonts.nix
    ../../modules/fcitx5.nix
    ../../modules/network.nix
    ../../modules/nvidia.nix
    ../../modules/tuigreet.nix
    ../../modules/steam.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users."${args.username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "input" ];
  };

  # Don't touch this
  system.stateVersion = "24.05";
}
