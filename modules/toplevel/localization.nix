{
  delib,
  host,
  ...
}:
delib.module {
  name = "localization";
  options = with delib;
    moduleOptions {
      enableFcitx5 = boolOption host.guiFeatured;
    };

  nixos.always = {
    i18n.defaultLocale = "ja_JP.UTF-8";
    time.timeZone = "Asia/Tokyo";
  };

  myconfig.always = {cfg, ...}: {
    programs.fcitx5.enable = cfg.enableFcitx5;
  };
}
