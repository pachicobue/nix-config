{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.alacritty";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      defaultTerminal = boolOption false;
    };

  myconfig.ifEnabled = {cfg, ...}: {
    commands.default.terminal = with lib;
      optionals cfg.defaultTerminal ["${getExe pkgs.alacritty}"];
  };

  home.ifEnabled = {
    programs.alacritty.enable = true;
  };
}
