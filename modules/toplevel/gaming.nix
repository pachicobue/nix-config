{
  delib,
  host,
  ...
}:
delib.module {
  name = "gaming";
  options = with delib;
    moduleOptions {
      enable = boolOption host.guiFeatured;
    };

  myconfig.ifEnabled = {
    programs.steam.enable = true;
  };
}
