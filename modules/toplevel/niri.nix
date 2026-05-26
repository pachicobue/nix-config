{delib, ...}:
delib.module {
  name = "niri";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      transparent = boolOption false;
    };

  myconfig.ifEnabled = {cfg, ...}: {
    services.windowManager.niri = {
      enable = true;
      inherit (cfg) transparent;
    };
    services.pipewire.enable = true;
  };
}
