{hostname}: {
  config,
  pkgs,
  inputs,
  ...
}: {
  # Host name
  networking.hostName = hostname;

  # System modules
  imports = [
    inputs.preservation.nixosModules.default
    ../../module/nixos/common.nix
    ../../module/nixos/fcitx.nix
    ../../module/nixos/network.nix
  ];

  # Boot Loader
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
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
  age.secrets.sho_sandbox_hashed_password = {
    symlink = true;
    file = "${inputs.my-nix-secret}/sho_sandbox_hashed_password.age";
  };
  programs.zsh.enable = true;
  users = {
    mutableUsers = false;
    users.root = {
      hashedPassword = "!"; # Disable root account
    };
    users.sho = {
      hashedPasswordFile = config.age.secrets.sho_sandbox_hashed_password.path;
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
