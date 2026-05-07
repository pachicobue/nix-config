{
  delib,
  host,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "xdg";

  home.always = {myconfig, ...}: let
    homeDirectory = "/home/${myconfig.constants.userName}";
  in {
    xdg = {
      dataHome = "${homeDirectory}/.local/share";
      cacheHome = "${homeDirectory}/.cache";
      stateHome = "${homeDirectory}/.local/state";
      configHome = "${homeDirectory}/.config";
      userDirs = let
        media = "${homeDirectory}/Media";
        files = "${homeDirectory}/Files";
      in {
        enable = true;
        setSessionVariables = true;
        download = "${homeDirectory}/Download";
        desktop = "${files}/Desktops";
        documents = "${files}/Documents";
        music = "${media}/Music";
        pictures = "${media}/Pictures";
        videos = "${media}/Videos";
        publicShare = "${files}/PublicShare";
        templates = "${files}/Templates";
      };

      autostart.enable = true;
      mimeApps.enable = true;

      portal = lib.mkIf host.guiFeatured {
        enable = true;
        xdgOpenUsePortal = true;
      };
    };

    home.packages = with pkgs; [
      handlr
    ];
  };
}
