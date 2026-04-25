{delib, ...}:
delib.module {
  name = "services.login-managers.greetd";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      backend = enumOption ["tuigreet" "regreet"] "tuigreet";
    };

  myconfig.ifEnabled = {cfg, ...}: {
    internal.greetd.tuigreet.enable = cfg.backend == "tuigreet";
    internal.greetd.regreet.enable = cfg.backend == "regreet";
  };
  nixos.ifEnabled = {
    services.greetd.enable = true;
  };
}
