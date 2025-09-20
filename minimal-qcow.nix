{ pkgs, ... }: {
  system.stateVersion = "25.11";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
      PermitEmptyPasswords = true;
      UsePAM = false;
    };
  };

  networking = {
    hostName = "minimal";
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };
  };

  users = {
    mutableUsers = false;
    users.root = {
      password = "";
      openssh.authorizedKeys.keys = [
      ];
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
  ];

  environment.etc."motd".text = ''
    NixOS VM Image - Ready for nixos-anywhere

    SSH: ssh root@<VM_IP> (no password required)
    Remote install: nixos-anywhere --flake '.#hostname' root@<VM_IP>
  '';
}
