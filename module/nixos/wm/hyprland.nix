{ delib, pkgs, lib, ... }:
delib.module {
  name = "wm.hyprland";
  options."wm.hyprland".enable = delib.boolOption false;
  nixos.ifEnabled = { myconfig, ... }:
    lib.mkIf (myconfig.host.desktop == "wayland") {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };
      services.displayManager.sessionPackages = [ pkgs.hyprland ];
    };
}
