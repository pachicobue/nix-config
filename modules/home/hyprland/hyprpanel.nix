{...}: {
  programs.hyprpanel = {
    enable = true;
    dontAssertNotificationDaemons = true;
    settings = {
      "bar.layouts" = {
        "*" = {
          "left" = [
            "workspaces"
            "windowtitle"
          ];
          "middle" = [
            "media"
          ];
          "right" = [
            "volume"
            "bluetooth"
            "clock"
            "power"
          ];
        };
      };
      "bar.clock.format" = "%m/%d(%a) %H:%M";
      "menus.clock.time.hideSeconds" = false;
      "menus.clock.time.military" = true;
      "menus.clock.weather.enabled" = false;
      "menus.power.showLabel" = true;
      "menus.power.confirmation" = false;
    };
  };
}
