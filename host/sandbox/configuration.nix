{hostname}: {
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
    kernelParams = [
      "console=ttyS0,115200n8"
      "earlyprintk=serial,ttyS0,115200"
      "loglevel=8"
      "debug"
      "initcall_debug"
      "ignore_loglevel"
      "debug"
    ];
  };

  # Register Users
  programs.zsh.enable = true;
  users = {
    users.root = {
      isSystemUser = true;
      password = "root";
    };
    users.sho = {
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

  preservation.enable = true;
  boot.initrd.systemd.enable = true;
  preservation.preserveAt."/persistent" = {
    directories = [
      "/etc"
      "/var"
    ];
    files = [
    ];
  };
}
