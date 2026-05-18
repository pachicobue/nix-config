{
  delib,
  lib,
  ...
}:
delib.module {
  name = "services.adguardhome";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      port = portOption 3000;
    };

  nixos.ifEnabled = {cfg, ...}: {
    services.adguardhome = {
      enable = true;
      openFirewall = true;
      mutableSettings = true;
      settings = {
        users = [];
      };
      inherit (cfg) port;
    };
    networking.firewall = {
      allowedTCPPorts = [cfg.port 53];
      allowedUDPPorts = [53];
    };
  };
}
