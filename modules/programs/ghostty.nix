{
  delib,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ghostty";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      defaultTerminal = boolOption false;
    };

  myconfig.ifEnabled = {cfg, ...}: {
    commands.default.terminal = with lib; optionals cfg.defaultTerminal ["${getExe pkgs.ghostty}" "+new-window"];
  };

  home.ifEnabled = {
    programs.ghostty = {
      enable = true;
      systemd.enable = true;
      settings = {
        confirm-close-surface = false;
      };
    };
  };
}
