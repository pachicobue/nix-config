{
  delib,
  host,
  ...
}:
delib.module {
  name = "discord";
  options = with delib;
    moduleOptions {
      enable = boolOption host.guiFeatured;
      client = enumOption ["webcord"] "webcord";
    };

  myconfig.ifEnabled = {cfg, ...}: {
    programs.webcord.enable = cfg.client == "webcord";
  };
}
