{...}: {
  imports = [
  ];
  programs.tcpdump.enable = true;
  services.immich = {
    enable = true;
    openFirewall = true;
    redis = {
      enable = true;
    };
    database = {
      enable = true;
    };
  };
  networking.firewall.enable = true;
}
