{ delib, ... }:
delib.module {
  name = "wluma";
  options.wluma.enable = delib.boolOption false;
  home.ifEnabled.services.wluma = {
    enable = true;
    systemd.enable = true;
  };
}
