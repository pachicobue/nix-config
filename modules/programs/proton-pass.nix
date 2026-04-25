{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.proton-pass";
  options = delib.singleEnableOption false;
  home.ifEnabled = {
    home.packages = [pkgs.proton-pass];
  };
}
