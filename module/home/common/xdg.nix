{ delib, ... }:
delib.module {
  name = "home.xdg";
  home.always = { myconfig, ... }: {
    xdg.userDirs = {
      enable = true;
      download = "/home/${myconfig.constants.userName}/Download";
      desktop = "/home/${myconfig.constants.userName}/Desktop";
      documents = "/home/${myconfig.constants.userName}/Document";
      music = "/home/${myconfig.constants.userName}/Music";
      pictures = "/home/${myconfig.constants.userName}/Picture";
      videos = "/home/${myconfig.constants.userName}/Video";
    };
  };
}
