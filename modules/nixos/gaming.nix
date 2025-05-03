{ pkgs, inputs, ... }:
{
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
  programs.steam = {
    enable = true;
    fontPackages = with pkgs; [
      noto-fonts-cjk-sans
    ];
  };
  environment.systemPackages = with pkgs; [
    mangohud
    lutris
  ];
}
