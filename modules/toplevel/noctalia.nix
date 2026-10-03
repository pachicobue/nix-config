{delib, ...}:
delib.module {
  name = "noctalia";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      defaultLauncher = boolOption true;
    };

  myconfig.ifEnabled = {cfg, ...}: {
    programs.noctalia = {
      enable = true;
      inherit (cfg) defaultLauncher;
    };
  };
}
