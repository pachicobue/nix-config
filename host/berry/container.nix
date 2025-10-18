{
  pkgs,
  config,
  hostConfig,
  ...
}: let
  # /media がメディアデータ用のSecondary Disk
  dataDisk = "/media";

  hostIp = "192.168.100.10";
  containers = [
    {
      name = "immich";
      hostPort = 1000;
      containerIp = "192.168.100.11";
      containerPort = config.services.immich.port;
    }
    {
      name = "silverbullet";
      hostPort = 1001;
      containerIp = "192.168.100.12";
      containerPort = config.services.silverbullet.listenPort;
    }
  ];
in {
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/tailscale/caddy-tailscale@v0.0.0-20251016183541-bd3189d81c73"
      ];
      hash = "sha256-CHthv5/kDtpr6WD57tGpbqt45WSsIypotqedBNqrnfI=";
    };
  };

  containers = builtins.listToAttrs (
    map (container: {
      name = container.name;
      value = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = hostIp;
        localAddress = container.containerIp;
        forwardPorts = [
          {
            hostPort = container.hostPort;
            containerPort = container.containerPort;
            protocol = "tcp";
          }
        ];
        bindMounts = {
          "/var/lib/${container.name}" = {
            hostPath = "${dataDisk}/${container.name}";
            isReadOnly = false;
          };
        };
        config = {...}: {
          system.stateVersion = "${hostConfig.stateVersion.nixos}";
          imports = [
            ../../container/${container.name}.nix
          ];
        };
        specialArgs = {
          inherit hostIp;
          hostPort = container.hostPort;
          containerIp = container.containerIp;
          containerPort = container.containerPort;
        };
      };
    })
    containers
  );

  networking.firewall.enable = true;

  systemd.tmpfiles.rules = map (container: "d ${dataDisk}/${container.name} 0755 root root -") containers;
}
