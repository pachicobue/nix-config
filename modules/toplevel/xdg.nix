{
  delib,
  host,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "xdg";

  options = with delib;
    moduleOptions {
      dataHome = pathOption "";
      cacheHome = pathOption "";
      stateHome = pathOption "";
      configHome = pathOption "";
      userDirs = {
        download = pathOption "";
        desktop = pathOption "";
        documents = pathOption "";
        music = pathOption "";
        pictures = pathOption "";
        videos = pathOption "";
        publicShare = pathOption "";
        templates = pathOption "";
      };
    };

  myconfig.always = {myconfig, ...}: let
    homeDirectory = "/home/${myconfig.constants.userName}";
    media = "${homeDirectory}/Media";
    files = "${homeDirectory}/Files";
  in {
    xdg = {
      dataHome = "${homeDirectory}/.local/share";
      cacheHome = "${homeDirectory}/.cache";
      stateHome = "${homeDirectory}/.local/state";
      configHome = "${homeDirectory}/.config";
      userDirs = {
        download = "${homeDirectory}/Download";
        desktop = "${files}/Desktops";
        documents = "${files}/Documents";
        music = "${media}/Music";
        pictures = "${media}/Pictures";
        videos = "${media}/Videos";
        publicShare = "${files}/PublicShare";
        templates = "${files}/Templates";
      };
    };
  };

  home.always = {myconfig, ...}: {
    xdg = {
      inherit (myconfig.xdg) dataHome cacheHome stateHome configHome;
      userDirs = {
        enable = true;
        setSessionVariables = true;
        inherit (myconfig.xdg.userDirs) download desktop documents music pictures videos publicShare templates;
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
