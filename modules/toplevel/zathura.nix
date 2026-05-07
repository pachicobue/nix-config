{
  delib,
  host,
  ...
}:
delib.module {
  name = "zathura";
  options = with delib;
    moduleOptions {
      enable = boolOption host.guiFeatured;
    };

  myconfig.ifEnabled = {
    programs.zathura.enable = true;
  };
}
