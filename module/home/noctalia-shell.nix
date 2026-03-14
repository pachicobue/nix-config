{inputs, ...}: {
  imports = [
    inputs.noctalia-shell.homeModules.default
  ];

  # configure options
  programs.noctalia-shell = {
    enable = true;
    settings = {
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
            {
              id = "ActiveWindow";
            }
            {
              id = "MediaMini";
            }
          ];
          center = [
            {
              id = "Workspace";
              hideUnoccupied = true;
            }
          ];
          right = [
            {
              id = "Tray";
            }
            {
              id = "NotificationHiistory";
            }
            {
              id = "Battery";
              hideIfNotDetected = true;
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
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
        enableDdcSupport = true;
      };
    };
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        catwalk = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        tailscale = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 2;
    };
    pluginSettings = {
      catwalk = {
        minimumThreshold = 25;
        hideBackground = true;
      };
      tailscale = {
        terminalCommand = "alacritty";
        compactMode = true;
      };
    };
  };
}
