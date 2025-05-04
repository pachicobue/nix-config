{ pkgs, ... }:
{
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
  programs.steam = {
    enable = true;
    fontPackages = with pkgs; [
      noto-fonts-cjk-sans
    ];
    protontricks.enable = true;
  };
  environment.systemPackages = with pkgs; [
    wineWowPackages.waylandFull
    mangohud
    lutris
  ];
}
