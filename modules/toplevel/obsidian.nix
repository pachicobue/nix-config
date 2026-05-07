{
  delib,
  host,
  ...
}:
delib.module {
  name = "obsidian";
  options = with delib;
    moduleOptions {
      enable = boolOption host.guiFeatured;
    };

  myconfig.ifEnabled = {
    programs.obsidian.enable = true;
  };
}
