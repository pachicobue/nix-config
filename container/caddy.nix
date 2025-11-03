{...}: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      # Immich - 写真管理
      "immich.berry.netbird.cloud".extraConfig = ''
        reverse_proxy immich.containers:2283
      '';

      # Silverbullet - ノート
      "silverbullet.berry.netbird.cloud".extraConfig = ''
        reverse_proxy silverbullet.containers:3000
      '';

      # Komga - 漫画/書籍管理
      "komga.berry.netbird.cloud".extraConfig = ''
        reverse_proxy komga.containers:8080
      '';
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };
}
