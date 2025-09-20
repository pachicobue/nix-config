{hostname}: {
  pkgs,
  inputs,
  ...
}: {
  # Host name
  networking.hostName = hostname;

  # System modules
  imports = [
    ../../module/nixos/common.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  # Boot configuration
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # Update this for your actual device

  # File systems configuration
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  # SSH Server
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  # Register Users
  programs.zsh.enable = true;
  users = {
    users.sho = {
      isNormalUser = true;
      group = "sho";
      extraGroups = [
        "wheel"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        # SSH公開鍵をここに追加
      ];
    };
    groups.sho = {};
  };

  # Enable sudo without password for wheel group
  security.sudo.wheelNeedsPassword = false;

}