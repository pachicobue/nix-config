{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.procs";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    home.packages = [pkgs.procs];
  };
}
