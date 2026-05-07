{
  delib,
  host,
  ...
}:
delib.module {
  name = "firefox";
  options = with delib;
    moduleOptions {
      enable = boolOption host.guiFeatured;
      defaultBrowser = boolOption false;
    };

  myconfig.ifEnabled = {cfg, ...}: {
    programs.firefox = {
      enable = true;
      inherit (cfg) defaultBrowser;
    };
  };
}
