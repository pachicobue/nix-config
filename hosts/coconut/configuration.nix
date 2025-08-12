{hostname}: {
  pkgs,
  inputs,
  ...
}: {
  # Host name
  networking.hostName = hostname;

  # System modules
  imports = [
    ../../modules/nixos/common.nix
    ../../modules/nixos/hyprland.nix
    ../../modules/nixos/fcitx.nix
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/udisk.nix
    ../../modules/nixos/yubikey.nix
    ../../modules/nixos/virtualization.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/network.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/keyboard.nix
  ];

  # Boot Loader
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      grub.enable = false;
      systemd-boot.enable = false;
      limine = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
      timeout = 1;
    };
    tmp = {
      cleanOnBoot = true;
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
        command = "${pkgs.tuigreet}/bin/tuigreet --cmd Hyprland";
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

  environment.enableAllTerminfo = true;
}
