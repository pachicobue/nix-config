{
  commonConfig,
  hostConfig,
  ...
}: {
  containers = {
    adguardhome = {
      autoStart = true;
      bindMounts = {
        "/var/lib/AdGuardHome" = {
          hostPath = "/var/lib/adguardhome-data";
          isReadOnly = false;
        };
      };
      config = {...}: {
        system.stateVersion = "${hostConfig.stateVersion.nixos}";
        imports = [
          ../../container/adguardhome.nix
        ];
      };
      specialArgs = {
        inherit commonConfig;
        inherit hostConfig;
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/adguardhome-data 0755 root root -"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      53 # DNS
      67 # DHCP
      68 # DHCP
      443 # DNS over HTTPS
      853 # DNS over TLS
      3000 # AdGuardHome Web UI
      80 # HTTP (for ACME challenge)
    ];
    allowedUDPPorts = [
      53 # DNS
      67 # DHCP
      68 # DHCP
      853 # DNS over QUIC
    ];
  };
}
