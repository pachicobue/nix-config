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
    ../../module/nixos/tailscale.nix
    ../../module/nixos/gaming.nix
    # ../../module/nixos/keyboard.nix

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
      };
      timeout = 3;
    };
    tmp = {
      cleanOnBoot = true;
    };
  };

  # Register Users
  programs.zsh.enable = true;
  users = {
    mutableUsers = false;
    users.root = {
      hashedPassword = "!"; # Disable root account
    };
    users.sho = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$.Iarvh3Ht.bUFAvigxxPD/$3BITVWgdIMokntQ/QvyfXahKNLeA6MFV8acqhgni746";
      extraGroups = [
        "wheel"
        "video"
        "input"
        "libvirt"
        "network"
      ];
      shell = pkgs.zsh;
    };
  };
  environment.enableAllTerminfo = true;
}
