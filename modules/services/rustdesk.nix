{delib, ...}:
delib.module {
  name = "services.rustdesk";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      openFirewall = boolOption true;
      relayHosts = listOption [];
    };

  nixos.ifEnabled = {cfg, ...}: {
    services.rustdesk-server = {
      enable = true;
      inherit (cfg) openFirewall;
      signal.relayHosts = cfg.relayHosts;
    };
  };
}
