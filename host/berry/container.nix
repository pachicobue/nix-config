{
  commonConfig,
  hostConfig,
  ...
}: let
  # /media がメディアデータ用のSecondary Disk
  dataDisk = "/media";
in {
  containers = {
  #   nextcloud = {
  #     autoStart = true;
  #     bindMounts = {
  #       "/etc/ssh/ssh_host_ed25519_key" = {
  #         hostPath = "/etc/ssh/ssh_host_ed25519_key";
  #         isReadOnly = true;
  #       };
  #       "/var/lib/nextcloud" = {
  #         hostPath = "${dataDisk}/nextcloud";
  #         isReadOnly = false;
  #       };
  #     };
  #     config = {...}: {
  #       system.stateVersion = "${hostConfig.stateVersion.nixos}";
  #       imports = [
  #         ../../container/nextcloud.nix
  #       ];
  #     };
  #     specialArgs = {
  #       inherit commonConfig;
  #       inherit hostConfig;
  #     };
  #   };
  # };

  systemd.tmpfiles.rules = [
    "d ${dataDisk}/nextcloud 0750 root root -"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80 # Nextcloud
    ];
  };
}
