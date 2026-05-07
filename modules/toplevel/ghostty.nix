{
  delib,
  host,
  ...
}:
delib.module {
  name = "ghostty";
  options = with delib;
    moduleOptions {
      enable = boolOption host.guiFeatured;
      defaultTerminal = boolOption true;
    };

  myconfig.ifEnabled = {cfg, ...}: {
    programs.ghostty = {
      enable = true;
      inherit (cfg) defaultTerminal;
    };
  };
}
