{
  delib,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.rio";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      defaultTerminal = boolOption false;
    };

  myconfig.ifEnabled = {cfg, ...}: {
    commands.default.terminal = lib.optionals cfg.defaultTerminal ["${lib.getExe pkgs.rio}"];
  };

  home.ifEnabled = {
    programs.rio = {
      enable = true;
      settings = {
        confirm-before-quit = false;
        copy-on-select = false;
      };
    };
  };
}
