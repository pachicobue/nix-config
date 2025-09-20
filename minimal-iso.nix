{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  system.stateVersion = "25.11";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  networking = {
    hostName = "minimal";
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };
    networkmanager.enable = true;
  };

  users = {
    mutableUsers = false;
    users.root = {
      hashedPassword = "$y$j9T$a2Lb9BjXbfD8W2bi2S74s1$6BY5X/g1.oEemrdNYD.ycerf8i0yLWwMGtk2pg/VU8/"; # "root"
    };
  };

  environment.systemPackages = with pkgs; [
    curl
    wget
    rsync
    kexec-tools
    openssh
    nano
    vim
    helix
    git
  ];
}
