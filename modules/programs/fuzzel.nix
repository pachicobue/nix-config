{
  delib,
  lib,
  ...
}:
delib.module {
  name = "services.fuzzel";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      setAsDefaultLauncher = boolOption false;
    };

  myconfig.ifEnabled = {cfg, ...}: {
    commands.default.launcher = with lib; optionals cfg.setAsDefaultLauncher ["${getExe pkgs.fuzzel}"];
  };

  home.ifEnabled = {
    programs.fuzzel.enable = true;
  };
}
