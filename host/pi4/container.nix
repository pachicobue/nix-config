{
  commonConfig,
  hostConfig,
  ...
}: {
  containers = {
    adguardhome = {
      autoStart = true;
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

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      53 # DNS
      67 # DHCP
      68 # DHCP
      3000 # AdGuardHome Web UI
    ];
    allowedUDPPorts = [
      53 # DNS
      67 # DHCP
      68 # DHCP
    ];
  };
}
