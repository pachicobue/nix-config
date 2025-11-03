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
        # 書籍/漫画データの読み取り専用マウント
        "/data" = {
          hostPath = "${dataDisk}/books";
          isReadOnly = true;
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
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d ${dataDisk}/immich 0755 root root -"
    "d ${dataDisk}/silverbullet 0755 root root -"
    "d ${dataDisk}/komga 0755 root root -"
    "d ${dataDisk}/books 0755 root root -"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80 # HTTP (Caddy)
      443 # HTTPS (Caddy)
      2283 # Immich (direct access)
      3000 # Silverbullet (direct access)
      8080 # Komga (direct access)
    ];
  };
}
