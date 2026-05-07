{delib, ...}:
delib.module {
  name = "programs.tealdeer";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.tealdeer = {
      enable = true;
      enableAutoUpdates = true;
    };
  };
}
