{
  delib,
  lib,
  ...
}:
delib.module {
  name = "programs.ghostty";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      setAsDefaultTerminal = boolOption false;
    };
  myconfig.ifEnabled = {cfg, ...}: {
    commands.default.terminal = lib.optional cfg.setAsDefaultTerminal ["ghostty"];
  };
  home.ifEnabled = {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        window-padding-x = 10;
        window-padding-y = 5;
        window-padding-balance = true;
      };
    };
  };
}
