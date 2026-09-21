{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.tailspin";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    home.packages = with pkgs; [
      tailspin
    ];
  };
}
