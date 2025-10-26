{...}: {
  imports = [
    ./hardware-configuration.nix

    ../../module/nixos/common.nix
    ../../module/nixos/openssh.nix
    ../../module/nixos/avahi.nix
    ../../module/nixos/netbird-client.nix
    ../../module/nixos/yubikey.nix
  ];

  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
      timeout = 3;
    };
  };
}
