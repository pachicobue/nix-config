{
  delib,
  pkgs,
  lib,
  inputs,
  ...
}: let
  noctaliaCmd = cmd: ["noctalia-shell" "ipc" "call"] ++ (lib.splitString " " cmd);
  desktopItem = pkgs.makeDesktopItem {
    name = "noctalia-shell";
    desktopName = "Noctalia Shell";
    exec = "noctalia-shell";
    noDisplay = true;
  };
in
  delib.module {
    name = "programs.noctalia-shell";
    options = with delib;
      moduleOptions {
        enable = boolOption false;
        defaultLauncher = boolOption false;
      };

    home.always = {
      imports = [inputs.noctalia-shell.homeModules.default];
    };

    myconfig.ifEnabled = {cfg, ...}: {
      commands.default.launcher = lib.optionals cfg.defaultLauncher (noctaliaCmd "launcher toggle");
    };

    home.ifEnabled = {myconfig, ...}: let
      inherit (myconfig.commands.default) terminal;
      pictureDir = myconfig.xdg.userDirs.pictures;
    in {
      programs.noctalia-shell = {
        enable = true;
        settings = {
          general = {
            avatarImage = "${pictureDir}/pachico.png";
            lockOnSuspend = false;
          };
          wallpaper = {
            directory = "${pictureDir}/wallpapers";
            automationEnabled = true;
            randomIntervalSec = 60;
          };
          bar = {
            position = "right";
            density = "spacious";
            showCapsule = true;
            widgets = {
              left = [
                {
                  id = "ControlCenter";
                }
                {
                  id = "Launcher";
                  icon = "rocket";
                }
                {id = "NotificationHistory";}
                {id = "MediaMini";}
              ];
              center = [
                {
                  id = "Workspace";
                  hideUnoccupied = true;
                }
              ];
              right = [
                {
                  id = "Battery";
                  hideIfNotDetected = true;
                }
                {id = "Volume";}
                {id = "Brightness";}
                {
                  id = "Clock";
                  formatVertical = "HH mm";
                  tooltipFormat = "MM/dd(ddd), HH:mm";
                }
              ];
            };
          };
          appLauncher = {
            terminalCommand = "${toString terminal} -e";
          };
          idle = {
            enabled = true;
            screenOffTimeout = 600;
            lockTimeout = 900;
            suspendTimeout = 1800;
            fadeDuration = 5;
          };
          brightness = {
            enforceMinimum = true;
            enableDdcSupport = true;
          };
        };
      };

      # 自動起動
      xdg.autostart.entries = [
        "${desktopItem}/share/applications/noctalia-shell.desktop"
      ];
    };
  }
