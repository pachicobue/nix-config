{...}: {
  imports = [
  ];
  programs.tcpdump.enable = true;
  services.immich = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
    redis = {
      enable = true;
    };
    database = {
      enable = true;
    };
  };
  networking.firewall.enable = true;
}
