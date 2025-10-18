{pkgs, ...}: {
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };
  programs.tcpdump.enable = true;
  environment.systemPackages = with pkgs; [
    tcpdump
    wget2
    curl
    bandwhich
    gping
    dog
  ];
}
