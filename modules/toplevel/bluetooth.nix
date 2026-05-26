{
  delib,
  host,
  ...
}:
delib.module {
  name = "bluetooth";
  options = with delib;
    moduleOptions {
      enable = boolOption host.bluetoothFeatured;
      withApplet = boolOption host.guiFeatured;
    };

  myconfig.ifEnabled = {cfg, ...}: {
    services.blueman = {
      enable = true;
      inherit (cfg) withApplet;
    };
  };
}
