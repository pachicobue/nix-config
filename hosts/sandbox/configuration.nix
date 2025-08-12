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
    ../../modules/nixos/network.nix
  ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Boot Loader
  boot.loader = {
    grub.enable = false;
    systemd-boot.enable = false;
    limine = {
      enable = true;
      efiSupport = true;
    };
  };

  # Register Users
  programs.zsh.enable = true;
  users = {
    users.admin = {
      password = "admin";
      isNormalUser = true;
      group = "admin";
      extraGroups = [
        "wheel"
        "network"
      ];
      shell = pkgs.zsh;
    };
    groups.admin = {};
  };

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 2048;
      cores = 3;
      graphics = false;
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  networking.firewall.allowedTCPPorts = [22];
  environment.systemPackages = with pkgs; [
    htop
    git
  ];
}
