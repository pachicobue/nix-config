{...}: {
  services.wluma = {
    enable = true;
    systemd.enable = true;
  };
}
