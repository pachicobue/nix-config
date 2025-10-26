{...}: {
  imports = [
  ];
  services.silverbullet = {
    enable = true;
    openFirewall = true;
  };
  networking.firewall.enable = true;
}
