{ delib, lib, ... }:
delib.module {
  name = "home.hyprland.hyprpolkitagent";
  home.always = { myconfig, ... }:
    lib.mkIf (myconfig."wm.hyprland".enable or false) {
      services.hyprpolkitagent.enable = true;
    };
}
