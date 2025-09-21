{
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };
  networking = {
    hostName = "minimal-installer";
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };
    networkmanager.enable = true;
  };
  users = {
    mutableUsers = false;
    users.root = {
      # "root"
      hashedPassword = "$y$j9T$hKLVmCPmSoF0IU0rw0O.Y/$pKcNb9WHwbRtyAzqpm/lqLJjhuNsUWlfpkQZa97VFeC";
    };
  };
  environment.systemPackages = with pkgs; [
    curl
    wget
    openssh
  ];
}
