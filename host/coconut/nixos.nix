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
    ../../module/nixos/netbird-client.nix
    # ../../module/nixos/avahi.nix
    ../../module/nixos/bluetooth.nix
    ../../module/nixos/usb.nix
    ../../module/nixos/yubikey.nix
    ../../module/nixos/regreet.nix
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

    # aarch64バイナリをQEMUでエミュレーション（Raspberry Pi用ビルドのため）
    binfmt.emulatedSystems = ["aarch64-linux"];
  };
}
