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
      443 # Tailscale Serve
      3000 # AdGuardHome Web UI
    ];
    allowedUDPPorts = [
      53 # DNS
      67 # DHCP
      68 # DHCP
    ];
  };

  # Tailscale Serve for AdGuardHome
  systemd.services.tailscale-serve = {
    description = "Tailscale Serve for AdGuard Home HTTPS";
    after = ["tailscaled.service" "container@adguardhome.service"];
    wants = ["container@adguardhome.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "/run/current-system/sw/bin/tailscale serve --bg --https 443 3000";
      ExecStop = "/run/current-system/sw/bin/tailscale serve --https 443 off";
    };
  };
}
