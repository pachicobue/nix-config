{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.espanso";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    home.packages = with pkgs; [
      espanso
    ];
  };
}
