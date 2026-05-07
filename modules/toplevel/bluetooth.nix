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
    };

  myconfig.ifEnabled = {
    services.blueman.enable = true;
  };
}
