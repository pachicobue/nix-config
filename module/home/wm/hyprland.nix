{ delib, pkgs, lib, ... }:
delib.module {
  name = "home.wm.hyprland";
  home.always = { myconfig, ... }:
    lib.mkIf (myconfig."wm.hyprland".enable or false) {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false;
      };
      home.packages = with pkgs; [ hyprshot ];
    };
}
