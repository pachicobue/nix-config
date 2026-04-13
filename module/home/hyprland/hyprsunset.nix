{ delib, lib, ... }:
delib.module {
  name = "home.hyprland.hyprsunset";
  home.always = { myconfig, ... }:
    lib.mkIf (myconfig."wm.hyprland".enable or false) {
      services.hyprsunset.enable = true;
    };
}
