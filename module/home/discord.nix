{ delib, pkgs, ... }:
delib.module {
  name = "discord";
  options.discord.enable = delib.boolOption false;
  home.ifEnabled.home.packages = [ pkgs.discord ];
}
