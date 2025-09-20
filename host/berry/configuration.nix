{hostname}: {
  pkgs,
  config,
  inputs,
  ...
}: {
  # Host name
  networking.hostName = hostname;

  # System modules
  imports = [
    ../../module/nixos/common.nix
    ../../module/nixos/fcitx.nix
    ../../module/nixos/bluetooth.nix
    ../../module/nixos/audio.nix
    ../../module/nixos/network.nix
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
  age.secrets.sho_berry_hashed_password = {
    symlink = true;
    file = "${inputs.my-nix-secret}/sho_berry_hashed_password.age";
  };
  programs.zsh.enable = true;
  users = {
    mutableUsers = false;
    users.root = {
      hashedPassword = "!"; # Disable root account
    };
    users.sho = {
      hashedPasswordFile = config.age.secrets.sho_berry_hashed_password.path;
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
