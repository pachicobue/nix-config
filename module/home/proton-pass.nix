{ delib, pkgs, ... }:
delib.module {
  name = "proton-pass";
  options."proton-pass".enable = delib.boolOption false;
  home.ifEnabled.home.packages = [ pkgs.proton-pass ];
}
