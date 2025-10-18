{
  hostIp,
  containerPort,
  ...
}: {
  imports = [
  ];
  programs.tcpdump.enable = true;
  services.immich = {
    enable = true;
    host = hostIp;
    port = containerPort;
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
