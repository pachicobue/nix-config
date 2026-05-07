{
  delib,
  host,
  ...
}:
delib.module {
  name = "zen-browser";
  options = with delib;
    moduleOptions {
      enable = boolOption host.guiFeatured;
      defaultBrowser = boolOption false;
    };

  myconfig.ifEnabled = {cfg, ...}: {
    programs.zen-browser = {
      enable = true;
      inherit (cfg) defaultBrowser;
    };
  };
}
