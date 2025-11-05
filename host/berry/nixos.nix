{inputs, ...}: {
  # System modules
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
    ./main-disk-config.nix
    ./extra-disk-config.nix

    ../../module/nixos/common.nix
    ../../module/nixos/openssh.nix
    ../../module/nixos/wakeonlan.nix
    # ../../module/nixos/netbird-client.nix
    ../../module/nixos/tailscale.nix

    ./container.nix
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
        maxGenerations = 5;
      };
      timeout = 3;
    };
  };
}
