{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprland";
  options = delib.singleEnableOption false;
  nixos.ifEnabled = {
    services.displayManager.sessionPackages = [pkgs.hyprland];
  };
  home.ifEnabled = {
    assertions = [
      {
        assertion = host.waylandFeatured;
        message = "Need 'wayland' feature.";
      }
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$terminal" = "alacritty";
        "$menu" = "fuzzel";
        "$browser" = "firefox-beta";
        "$mainMod" = "SUPER";
        "$subMod" = "ALT";
        exec-once = [
          "fcitx5 -d -r"
          "[workspace special silent] $terminal"
          "[workspace 1 silent] $browser"
        ];
        exec = [];
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
          animation = ["specialWorkspace,1,4,default,slidefadevert -50%"];
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
        bind = [
          "$mainMod, SPACE, exec, $menu"
          "$mainMod, T, exec, $terminal"
          "$mainMod, O, exec, $obsidian"
          "$mainMod, B, exec, $browser"
          "$mainMod, C, killactive"
          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"
          "$mainMod SHIFT, H, movewindow, l"
          "$mainMod SHIFT, L, movewindow, r"
          "$mainMod SHIFT, K, movewindow, u"
          "$mainMod SHIFT, J, movewindow, d"
          "$mainMod, A, workspace, 1"
          "$mainMod, S, workspace, 2"
          "$mainMod, D, workspace, 3"
          "$mainMod, F, workspace, 4"
          "$subMod, TAB, togglespecialworkspace"
          "$mainMod, G, togglespecialworkspace"
          "$mainMod SHIFT, A, movetoworkspace, 1"
          "$mainMod SHIFT, S, movetoworkspace, 2"
          "$mainMod SHIFT, D, movetoworkspace, 3"
          "$mainMod SHIFT, F, movetoworkspace, 4"
          "$mainMod SHIFT, G, movetoworkspace, special"
          "$subMod SHIFT, TAB, togglespecialworkspace"
        ];
      };
    };
    services.hyprpolkitagent.enable = true;
  };
}
