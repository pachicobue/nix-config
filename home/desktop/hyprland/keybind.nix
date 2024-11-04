{ ... }:
{

  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    "$subMod" = "ALT";
    bind = [
      "$subMod, SPACE, exec, $menu"
      "$subMod, TAB, togglespecialworkspace"
      "$mainMod, T, exec, $terminal"
      "$mainMod, C, killactive"
      "$mainMod, H, movefocus, l"
      "$mainMod, L, movefocus, r"
      "$mainMod, K, movefocus, u"
      "$mainMod, J, movefocus, d"
      "$mainMod SHIFT, H, movewindow, l"
      "$mainMod SHIFT, L, movewindow, r"
      "$mainMod SHIFT, K, movewindow, u"
      "$mainMod SHIFT, J, movewindow, d"
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 0, movetoworkspace, special"

    ];
  };
}
