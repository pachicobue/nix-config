{config, ...}: {
  wayland.windowManager.hyprland.settings = {
    "$terminal" = "alacritty";
    "$menu" = "fuzzel";
    "$browser" = "firefox-beta";
    exec-once = [
      "hyprpanel"
      "hyprctl setcursor ${config.stylix.cursor.name} 24"
      "fcitx5 -d -r"
      "fusuma -d"
      "[workspace special silent] $terminal"
      "[workspace 1 silent] $browser"
    ];
    exec = [
    ];
    windowrule = ["pseudo, noblur, class:(fcitx)"];
    windowrulev2 = ["noblur,class:^()$,title:^()$"];
    monitor = "HDMI-A-1,highrr,0x0,1";
    input = {
      kb_layout = "us";
      kb_options = ["ctrl:nocaps"];
      follow_mouse = 1;
    };
    general = {
      gaps_in = 5;
      gaps_out = 20;
      border_size = 2;
      resize_on_border = true;
      allow_tearing = true;
    };
    animations = {
      enabled = true;
      animation = [
        "specialWorkspace,1,4,default,slidefadevert -50%"
      ];
    };
    decoration = {
      rounding = 10;
      dim_inactive = true;
      dim_strength = 0.2;
    };
    cursor = {
      hide_on_key_press = true;
    };
    misc = {
      middle_click_paste = false;
      mouse_move_enables_dpms = false;
      focus_on_activate = true;
    };
  };
}
