{ pkgs, flake, ... }:
let
  defaultUser = "sho";
in
{
  networking.hostName = "nixos-desktop";
  imports = [
    ./hardware-configuration.nix
    flake.modules.nixos.${defaultUser}
    flake.modules.nixos.common

    # flake.modules.nixos.plymouth
    flake.modules.nixos.bluetooth
    flake.modules.nixos.udisk
    flake.modules.nixos.yubikey

    flake.modules.nixos.virtualization
    flake.modules.nixos.audio
    flake.modules.nixos.nvidia
    flake.modules.nixos.fcitx
    flake.modules.nixos.network
    flake.modules.nixos.gaming
    flake.modules.nixos.hyprland
    flake.modules.nixos.keyboard
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
