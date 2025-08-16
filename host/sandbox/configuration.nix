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
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
    kernelParams = [
      "console=ttyS0,115200n8"
      "console=tty0"
      "earlyprintk=serial,ttyS0,115200"
      "loglevel=8" # より詳細なレベル
      "debug"
      "initcall_debug"
      "ignore_loglevel"
      "debug"
      "loglevel=7"
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
  # environment.enableAllTerminfo = true;

  # pverservation required initrd using systemd.
  # preservation.enable = true;
  # boot.initrd.systemd.enable = true;
  # preservation.preserveAt."/persistent" = {
  #   directories = [
  #     "/etc"
  #     "/var"
  #   ];
  #   files = [
  #   ];
  # };
}
