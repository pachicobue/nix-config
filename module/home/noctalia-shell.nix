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
        density = "default";
        widgets = {
          left = [
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
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
          ];
        };
      };
      colorSchemes = {
        useWallpaperColors = false;
        predefinedScheme = "Noctalia (default)";
        darkMode = true;
        schedulingMode = "location";
        generationMethod = "tonal-spot";
        monitorForColors = "";
      };
      nightLight = {
        enabled = true;
        forced = false;
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
        brightnessStep = 5;
        enforceMinimum = true;
        enableDdcSupport = true;
      };
    };
  };
}
