{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.rip";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    home.packages = with pkgs; [
      rm-improved
    ];
  };
}
