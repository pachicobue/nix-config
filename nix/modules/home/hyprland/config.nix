{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    "$terminal" = "ghostty";
    "$menu" = "fuzzel";
    "$browser" = "firefox-beta";
    exec-once = [
      "fcitx5 -d -r"
      "mako"
      "waybar"
      "[workspace special silent] $terminal"
      "[workspace 1 silent] $browser"
    ];
    windowrule = [ "pseudo, noblur, class:(fcitx)" ];
    windowrulev2 = [ "noblur,class:^()$,title:^()$" ];
    monitor = "HDMI-A-1,highrr,0x0,1";
    input = {
      kb_layout = "us";
      kb_options = [ "ctrl:nocaps" ];
      repeat_delay = 300;
      repeat_rate = 30;
      follow_mouse = 1;
    };
    general = {
      gaps_in = 5;
      gaps_out = 20;
      border_size = 2;
      resize_on_border = true;
      allow_tearing = false;
    };
    animations = {
      enabled = true;
    };
    decoration = {
      rounding = 10;
      blur = {
        enabled = false;
        size = 3;
        passes = 1;
      };
      dim_inactive = true;
    };
    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };
  };
}
