{ lib, ... }:
{
  wayland.windowManager.hyprland.settings = {
    "$terminal" = "kitty";
    "$menu" = "walker";
    exec-once = [
      "fcitx5 -d -r"
      "fcitx5-remote -r"
      "mako"
      "waybar"
      "[workspace special silent] $terminal"
      "[workspace 1 silent] firefox"
      "[workspace 2 silent] emacs"
    ];
    windowrule = [ "pseudo, noblur, class:(fcitx)" ];
    windowrulev2 = [ "noblur,class:^()$,title:^()$" ];
    input = {
      kb_layout = "us";
      kb_options = [ "ctrl:nocaps" ];
      repeat_delay = 300;
      repeat_rate = 30;
      follow_mouse = 1;
      sensitivity = lib.mkDefault (0.0);
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
      animation = "workspaces, 0, 2, default";
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
