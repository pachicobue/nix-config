{
  delib,
  lib,
  ...
}:
delib.module {
  name = "fuzzel";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      setAsDefaultLauncher = boolOption false;
    };

  myconfig.ifEnabled = {cfg, ...}: {
    commands.default.launcher = lib.optional cfg.setAsDefaultLauncher ["fuzzel"];
  };
  home.ifEnabled = {
    programs.fuzzel.enable = true;
  };
}
