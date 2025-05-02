{ flake, ... }:
let
  defaultUser = "sho";
in
{
  imports = [
    flake.modules.nixos.${defaultUser}
    ./hardware-configuration.nix
    flake.modules.nixos.common

    flake.modules.nixos.fcitx
  ];

  # Bootloader.
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/vda";
      useOSProber = true;
    };
  };

  # Auto login
  services.getty.autologinUser = defaultUser;
}
