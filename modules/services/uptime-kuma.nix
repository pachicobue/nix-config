{delib, ...}:
delib.module {
  name = "services.uptime-kuma";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      port = portOption 3001;
      bindHost = strOption "localhost";
    };

  nixos.ifEnabled = {cfg, ...}: {
    services.uptime-kuma = {
      enable = true;
      settings = {
        HOST = cfg.bindHost;
        PORT = toString cfg.port;
      };
    };
    networking.firewall.allowedTCPPorts = [cfg.port];
  };
}
