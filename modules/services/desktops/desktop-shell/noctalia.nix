{
  delib,
  host,
  lib,
  ...
}: let
  noctaliaCmd = cmd: ["noctalia-shell" "ipc" "call"] ++ (lib.splitString " " cmd);
in
  delib.module {
    name = "services.desktop-shell.noctalia";
    options = with delib;
      moduleOptions {
        enable = readOnly (boolOption false);
        setAsDefaultLauncher = readOnly (boolOption false);
      };

    myconfig.ifEnabled = {cfg, ...}: {
      commands.default.launcher = lib.optional cfg.setAsDefaultLauncher (noctaliaCmd "launcher toggle");
      commands.shouldAutostart = [
        ["noctalia-shell"]
      ];
    };

    home.ifEnabled = {
      programs.noctalia-shell = {
        enable = true;
        settings = {
          general = {lockOnSuspend = false;};
          bar = {
            position = "right";
            density = "spacious";
            showCapsule = true;
            widgets = {
              left = [
                {
                  id = "ControlCenter";
                  useDistroLogo = true;
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
          colorSchemes = {
            useWallpaperColors = false;
            schedulingMode = "location";
          };
          nightLight = {
            enabled = true;
            autoSchedule = true;
            nightTemp = "4000";
            dayTemp = "6500";
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
            enableDdcSupport = host.display != [];
          };
        };
      };
    };
  }
