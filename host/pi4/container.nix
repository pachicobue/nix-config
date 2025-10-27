{
  config,
  hostConfig,
  ...
}: let
  hostIp = "192.168.100.10";
in {
  containers = {
    adguardhome = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = hostIp;
      localAddress = "192.168.100.1";
      forwardPorts = [
        {
          containerPort = 3000;
          hostPort = 3000;
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

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [3000];
  };
}
