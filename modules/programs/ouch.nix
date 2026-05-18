{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ouch";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    home.packages = with pkgs; [
      ouch
    ];
  };
}
