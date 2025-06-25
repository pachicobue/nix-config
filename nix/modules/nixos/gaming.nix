{ pkgs, ... }:
{
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    fontPackages = with pkgs; [
      noto-fonts-cjk-sans
    ];
    protontricks.enable = true;
  };
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override { extraPkgs = pkgs: with pkgs; [ noto-fonts-cjk-sans ]; };
  };
  environment.systemPackages = with pkgs; [
    wineWowPackages.waylandFull
    mangohud
  ];
}
