{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    "$subMod" = "ALT";
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
}
