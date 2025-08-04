{hostname}: {
  pkgs,
  inputs,
  ...
}: {
  # Host name
  networking.hostName = hostname;

  # System modules
  imports = [
    inputs.catppuccin.nixosModules.catppuccin

    ../../modules/nixos/common.nix
    ../../modules/nixos/hyprland.nix
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/udisk.nix
    ../../modules/nixos/yubikey.nix
    ../../modules/nixos/virtualization.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/fcitx.nix
    ../../modules/nixos/network.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/keyboard.nix
  ];

  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_zen;
    consoleLogLevel = 3;
    # tmp is RAM
    tmp = {
      useTmpfs = true;
    };
    # Boot Loader
    loader = {
      grub.enable = false;
      systemd-boot.enable = false;
      limine = {
        enable = true;
        secureBoot = {
          enable = true;
        };
        efiSupport = true;
        enableEditor = true;
      };
    };
  };

  # Login Manager
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "Hyprland";
        user = "sho";
      };
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
      };
    };
  };

  # Register Users
  programs.zsh.enable = true;
  users = {
    users.sho = {
      isNormalUser = true;
      group = "sho";
      extraGroups = [
        "wheel"
        "video"
        "input"
        "uinput"
        "libvirt"
        "network"
      ];
      shell = pkgs.zsh;
    };
    groups.sho = {};
  };

  # Theme
  catppuccin = {
    plymouth.enable = true;
  };
}
