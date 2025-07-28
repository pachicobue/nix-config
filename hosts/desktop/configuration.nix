{ pkgs, inputs, ... }:
let
  defaultUser = "sho";
in
{
  networking.hostName = "nixos-desktop";

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
  catppuccin.grub = {
    enable = true;
  };

  # Auto login
  # services.getty.autologinUser = defaultUser;
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "Hyprland";
        user = defaultUser;
      };
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = defaultUser;
      };
    };
  };
}
