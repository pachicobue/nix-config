{hostName}: {
  config,
  pkgs,
  inputs,
  ...
}: {
  # Host name
  networking.hostName = hostName;

  # System modules
  imports = [
    ../../module/nixos/common.nix
    ../../module/nixos/fcitx.nix
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
      timeout = 3;
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
      hashedPassword = "$y$j9T$f9mAf7huGP5kDCIEeus/a/$7iNCLyOyXdDJYaF.Z2VdvZMtbrBDzZsR56mLAo7LcU1";
      isNormalUser = true;
      group = "sho";
      extraGroups = [
        "wheel"
      ];
      shell = pkgs.zsh;
    };
    groups.sho = {};
  };
  environment.enableAllTerminfo = true;
}
