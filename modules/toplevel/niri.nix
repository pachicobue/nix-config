{delib, ...}:
delib.module {
  name = "niri";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
    };

  myconfig.ifEnabled = {...}: {
    services.windowManager.niri = {
      enable = true;
    };
    services.pipewire.enable = true;
  };
}
