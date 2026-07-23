{delib, ...}:
delib.module {
  name = "services.forgejo";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      port = portOption 3000;
      bindHost = strOption "localhost";
      # Web上での新規ユーザー登録を禁止する (アカウントはCLIの`forgejo admin user create`で作成する)
      disableRegistration = boolOption true;
    };

  nixos.ifEnabled = {cfg, ...}: {
    services.forgejo = {
      enable = true;
      settings.server = {
        HTTP_ADDR = cfg.bindHost;
        HTTP_PORT = cfg.port;
      };
      settings.service.DISABLE_REGISTRATION = cfg.disableRegistration;
    };
    networking.firewall.allowedTCPPorts = [cfg.port];
  };
}
