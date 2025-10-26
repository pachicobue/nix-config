{
  config,
  hostConfig,
  ...
}: let
  hostIp = "192.168.100.0";
  # /media がメディアデータ用のSecondary Disk
  dataDisk = "/media";
in {
  containers = {
    immich = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = hostIp;
      localAddress = "192.168.100.1";
      forwardPorts = [
        rec {
          containerPort = config.services.immich.port;
          hostPort = containerPort;
          protocol = "tcp";
        }
      ];
      config = {...}: {
        system.stateVersion = "${hostConfig.stateVersion.nixos}";
        imports = [
          ../../container/immich.nix
        ];
      };
    };
    silverbullet = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = hostIp;
      localAddress = "192.168.100.2";
      forwardPorts = [
        rec {
          containerPort = config.services.silverbullet.listenPort;
          hostPort = containerPort;
          protocol = "tcp";
        }
      ];
      config = {...}: {
        system.stateVersion = "${hostConfig.stateVersion.nixos}";
        imports = [
          ../../container/silverbullet.nix
        ];
      };
    };
  };
  systemd.tmpfiles.rules = [
    "d ${dataDisk}/immich 0755 root root -"
    "d ${dataDisk}/silverbullet 0755 root root -"
  ];

  networking.firewall.enable = true;
}
