{ delib, pkgs, ... }:
delib.module {
  name = "obsidian";
  options.obsidian.enable = delib.boolOption false;
  home.ifEnabled.home.packages = [ pkgs.obsidian ];
}
