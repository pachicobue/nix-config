{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "services.forgejo";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      port = portOption 3000;
      bindHost = strOption "localhost";
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = with pkgs; [forgejo-lts];
    services.forgejo = {
      enable = true;
      settings = {
        admin = {
          DISABLE_REGULAR_ORG_CREATION = true;
        };
        repository = {
          DISABLE_STARS = true;
          DISABLE_FORKS = true;
        };
        server = {
          HTTP_ADDR = cfg.bindHost;
          HTTP_PORT = cfg.port;
        };
        "service.explore" = {
          REQUIRE_SIGNIN_VIEW = true;
          DISABLE_USERS_PAGE = true;
          DISABLE_ORGANIZATIONS_PAGE = true;
        };
        packages = {
          ENABLED = false;
        };
      };
    };
    networking.firewall.allowedTCPPorts = [cfg.port];
  };
}
