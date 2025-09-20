{pkgs, ...}: {
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
    fontPackages = with pkgs; [
      noto-fonts-cjk-sans
    ];
  };
  environment.systemPackages = [
    pkgs.mangohud
  ];
  programs.gamemode.enable = true;
}
