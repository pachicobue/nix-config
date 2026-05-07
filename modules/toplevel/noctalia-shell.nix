{delib, ...}:
delib.module {
  name = "noctalia-shell";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      defaultLauncher = boolOption true;
    };

  myconfig.ifEnabled = {cfg, ...}: {
    programs.noctalia-shell = {
      enable = true;
      inherit (cfg) defaultLauncher;
    };
  };
}
