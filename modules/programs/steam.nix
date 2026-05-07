{delib, ...}:
delib.module {
  name = "programs.steam";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    programs.steam = {
      enable = true;
      protontricks.enable = true;
      gamescopeSession.enable = true;
    };
  };
}
