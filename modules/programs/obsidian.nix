{delib, ...}:
delib.module {
  name = "programs.obsidian";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.obsidian = {
      enable = true;
      cli.enable = true;
    };
  };
}
