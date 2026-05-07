{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.waypipe";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    home.packages = with pkgs; [waypipe];
  };
}
