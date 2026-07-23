{delib, ...}:
delib.module {
  name = "services.atticd";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      port = portOption 8080;
      bindHost = strOption "localhost";
    };

  nixos.ifEnabled = {
    cfg,
    myconfig,
    ...
  }: {
    # atticdはDynamicUserで動くため、固定UIDなしで起動時にsecretを読めるよう
    # パーミッションを開放する (forgejo-runnerと同じ理由)
    age.secrets.atticd.mode = "0444";

    services.atticd = {
      enable = true;
      environmentFile = myconfig.agenix-rekey.secretPaths.atticd;
      settings = {
        listen = "${cfg.bindHost}:${toString cfg.port}";
      };
    };
    networking.firewall.allowedTCPPorts = [cfg.port];
  };
}
