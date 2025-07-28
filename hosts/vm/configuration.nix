{ inputs, ... }:
let
  defaultUser = "sho";
in
{

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
