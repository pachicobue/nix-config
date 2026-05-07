{
  delib,
  host,
  ...
}:
delib.module {
  name = "zed-editor";
  options = with delib;
    moduleOptions {
      enable = boolOption host.guiFeatured;
    };

  myconfig.ifEnabled = {
    programs.zed-editor.enable = true;
  };
}
