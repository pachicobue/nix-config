{
  hostIp,
  containerPort,
  ...
}: {
  imports = [
  ];
  services.silverbullet = {
    enable = true;
    listenAddress = hostIp;
    listenPort = containerPort;
    openFirewall = true;
  };
  networking.firewall.enable = true;
}
