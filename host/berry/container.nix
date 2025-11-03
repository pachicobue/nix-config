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
  };

  systemd.tmpfiles.rules = [
    "d ${dataDisk}/immich 0755 root root -"
    "d ${dataDisk}/silverbullet 0755 root root -"
    "d ${dataDisk}/komga 0755 root root -"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      2283 # Immich
      3000 # Silverbullet
      8080 # Komga
    ];
  };
}
