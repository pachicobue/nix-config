{ delib, pkgs, lib, ... }:
delib.module {
  name = "gaming";
  options.gaming.enable = delib.boolOption false;
  nixos.ifEnabled = { myconfig, ... }: {
    programs.steam = {
      enable = true;
      protontricks.enable = true;
      gamescopeSession.enable = true;
      extest.enable = lib.mkIf (myconfig.host.desktop == "x") true;
      fontPackages = with pkgs; [ noto-fonts-cjk-sans ];
    };
    programs.gamemode.enable = true;
  };
}
