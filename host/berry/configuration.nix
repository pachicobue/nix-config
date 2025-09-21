{hostName}: {
  pkgs,
  config,
  inputs,
  ...
}: {
  # Host name
  networking.hostName = hostName;

  # System modules
  imports = [
    ../../module/nixos/common.nix
    ../../module/nixos/fcitx.nix
    ../../module/nixos/bluetooth.nix
    ../../module/nixos/audio.nix
    ../../module/nixos/network.nix
    ../../module/nixos/ssh.nix
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
      timeout = 1;
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
      # 本当はagenixでさらに隠蔽したいがremote-installが面倒なので
      hashedPassword = "$y$j9T$OHc4xS4cpDtjJcZlK/QdT0$dCD/Gr55hB7yUseg4PplL6LIwo7AqLdfucPtx5fJ4NC";
      isNormalUser = true;
      group = "sho";
      extraGroups = [
        "wheel"
        "video"
        "input"
        "network"
      ];
      shell = pkgs.zsh;
    };
    groups.sho = {};
  };
  environment.enableAllTerminfo = true;
}
