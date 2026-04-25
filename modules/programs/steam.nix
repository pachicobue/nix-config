{
  delib,
  pkgs,
  host,
  ...
}:
delib.module {
  name = "programs.steam";
  options = delib.singleEnableOption host.isPC;
  nixos.ifEnabled = {
    programs.steam = {
      enable = true;
      protontricks.enable = true;
      gamescopeSession.enable = true;
      extest.enable = host.x11Featured;
      fontPackages = with pkgs; [noto-fonts-cjk-sans];
    };
  };
}
