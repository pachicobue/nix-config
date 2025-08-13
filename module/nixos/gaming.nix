{pkgs, ...}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
    fontPackages = with pkgs; [
      noto-fonts-cjk-sans
    ];
  };
}
