{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
    ./disk-config.nix

    ../../module/nixos/common.nix
    ../../module/nixos/openssh.nix
    ../../module/nixos/fcitx.nix
    ../../module/nixos/audio.nix
    ../../module/nixos/nvidia.nix
    ../../module/nixos/gaming.nix
    ../../module/nixos/wakeonlan.nix
    ../../module/nixos/tailscale.nix
    ../../module/nixos/bluetooth.nix
    ../../module/nixos/usb.nix
    ../../module/nixos/yubikey.nix
    # ../../module/nixos/keyboard.nix
    ../../module/nixos/regreet.nix
    # ../../module/nixos/hyprland.nix
    # ../../module/nixos/niri.nix
  ];

  # Boot Loader
  boot = {
    loader = {
      grub.enable = false;
      systemd-boot.enable = false;
      limine = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        maxGenerations = 10;
      };
      timeout = 3;
    };
    tmp.cleanOnBoot = true;
  };
}
