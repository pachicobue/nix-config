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
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              id = "Clock";
              formatVertical = "HH mm";
              tooltipFormat = "MM/dd(ddd), HH:mm";
            }
          ];
        };

        brightness = {
          enableDdcSupport = true;
        };
      };
    };
  };
}
