{hostConfig, ...}: let
  # /media がメディアデータ用のSecondary Disk
  dataDisk = "/media";
in {
  containers = {
    immich = {
      autoStart = true;
      bindMounts = {
        "/var/lib/immich" = {
          hostPath = "${dataDisk}/immich";
          isReadOnly = false;
        };
      };
      config = {...}: {
        system.stateVersion = "${hostConfig.stateVersion.nixos}";
        imports = [
          ../../container/immich.nix
        ];
      };
    };
    silverbullet = {
      autoStart = true;
      bindMounts = {
        "/var/lib/silverbullet" = {
          hostPath = "${dataDisk}/silverbullet";
          isReadOnly = false;
        };
      };
      config = {...}: {
        system.stateVersion = "${hostConfig.stateVersion.nixos}";
        imports = [
          ../../container/silverbullet.nix
        ];
      };
    };
    komga = {
      autoStart = true;
      bindMounts = {
        "/var/lib/komga" = {
          hostPath = "${dataDisk}/komga";
          isReadOnly = false;
        };
      };
      config = {...}: {
        system.stateVersion = "${hostConfig.stateVersion.nixos}";
        imports = [
          ../../container/komga.nix
        ];
      };
    };
    caddy = {
      autoStart = true;
      config = {...}: {
        system.stateVersion = "${hostConfig.stateVersion.nixos}";
        imports = [
          ../../container/caddy.nix
        ];
        services.caddy.virtualHosts = {
          # Immich - 写真管理
          "immich.berry.netbird.cloud".extraConfig = ''
            reverse_proxy immich.containers:2283
          '';

          # Silverbullet - ノート
          "silverbullet.berry.netbird.cloud".extraConfig = ''
            reverse_proxy silverbullet.containers:3000
          '';

          # Komga - 漫画/書籍管理
          "komga.berry.netbird.cloud".extraConfig = ''
            reverse_proxy komga.containers:8080
          '';
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d ${dataDisk}/immich 0755 root root -"
    "d ${dataDisk}/silverbullet 0755 root root -"
    "d ${dataDisk}/komga 0755 root root -"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80 # HTTP (Caddy)
      443 # HTTPS (Caddy)
    ];
  };
}
