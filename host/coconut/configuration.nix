{hostName}: {
  pkgs,
  inputs,
  ...
}: {
  # Host name
  networking.hostName = hostName;

  # System modules
  imports = [
    ../../module/nixos/common.nix
    ../../module/nixos/common-wayland.nix
    # ../../module/nixos/hyprland.nix
    ../../module/nixos/niri.nix
    ../../module/nixos/fcitx.nix
    ../../module/nixos/bluetooth.nix
    ../../module/nixos/udisk.nix
    ../../module/nixos/yubikey.nix
    # ../../module/nixos/virtualization.nix
    ../../module/nixos/audio.nix
    ../../module/nixos/nvidia.nix
    ../../module/nixos/network.nix
    ../../module/nixos/ssh.nix
    ../../module/nixos/gaming.nix
    # ../../module/nixos/keyboard.nix
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
      timeout = 3;
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
        command = "zsh";
        user = "sho";
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --cmd zsh";
      };
    };
  };

  # Register Users
  programs.zsh.enable = true;
  users = {
    users.sho = {
      isNormalUser = true;
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
