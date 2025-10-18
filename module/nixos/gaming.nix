{
  pkgs,
  hostConfig,
  lib,
  ...
}: {
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    gamescopeSession.enable = true;
    extest.enable = lib.mkIf (hostConfig.desktop == "x") true;
    fontPackages = with pkgs; [
      noto-fonts-cjk-sans
    ];
  };
  programs.gamemode.enable = true;
}
