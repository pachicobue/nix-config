{
  delib,
  lib,
  ...
}:
delib.module {
  name = "services.immich";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      port = portOption 2283;
      bindHost = strOption "localhost";
      mediaLocation = pathOption "/var/lib/immich";
    };

  nixos.ifEnabled = {cfg, ...}: {
    services.immich = {
      enable = true;
      openFirewall = true;
      host = cfg.bindHost;
      environment = {
        IMMICH_IGNORE_MOUNT_CHECK_ERRORS = "true";
      };
      inherit (cfg) mediaLocation;
    };
  };
}
