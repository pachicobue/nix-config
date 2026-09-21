{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.scooter";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    home.packages = with pkgs; [
      scooter
    ];
  };
}
