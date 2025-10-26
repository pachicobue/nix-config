{
  config,
  hostConfig,
  ...
}: let
  hostIp = "192.168.100.0";
in {
  containers = {
    adguardhome = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = hostIp;
      localAddress = "192.168.100.1";
      forwardPorts = [
        rec {
          containerPort = config.services.adguardhome.port;
          hostPort = containerPort;
          protocol = "tcp";
        }
      ];
      config = {...}: {
        system.stateVersion = "${hostConfig.stateVersion.nixos}";
        imports = [
          ../../container/adguardhome.nix
        ];
      };
    };
  };
  networking.firewall.enable = true;
}
