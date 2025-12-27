{...}: {
  services.filebrowser = {
    enable = true;
    openFirewall = true;
    settings = {
      port = 8081;
      address = "0.0.0.0";
      root = "/media";
    };
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    # Run jellyfin as filebrowser user to avoid permission issues
    user = "filebrowser";
    group = "filebrowser";
  };
}
