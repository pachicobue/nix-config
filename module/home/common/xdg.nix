{config, ...}: {
  xdg.userDirs = {
    enable = true;
    download = "${config.home.homeDirectory}/Download";
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Document";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Picture";
    videos = "${config.home.homeDirectory}/Video";
  };
}
