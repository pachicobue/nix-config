{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.rustdesk";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    home.packages = [pkgs.rustdesk];
  };
}
