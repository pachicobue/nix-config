{
  delib,
  lib,
  host,
  ...
}:
delib.module {
  name = "programs.alacritty";
  options = with delib;
    moduleOptions {
      enable = boolOption host.isPC;
      setAsDefaultTerminal = boolOption false;
    };

  myconfig.ifEnabled = {cfg, ...}: {
    commands.default.terminal = lib.optional cfg.setAsDefaultTerminal ["alacritty"];
  };
  home.ifEnabled.programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 10;
          y = 5;
        };
      };
    };
  };
}
