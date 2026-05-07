{
  delib,
  host,
  ...
}:
delib.module {
  name = "dolphin";
  options = with delib;
    moduleOptions {
      enable = boolOption host.guiFeatured;
    };

  myconfig.ifEnabled = {
    programs.dolphin.enable = true;
  };
}
