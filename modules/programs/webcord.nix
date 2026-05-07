{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.webcord";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    home.packages = [pkgs.webcord];
  };
}
