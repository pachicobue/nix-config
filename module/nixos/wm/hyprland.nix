{
  pkgs,
  lib,
  hostConfig,
  ...
}:
lib.mkIf (hostConfig.desktop == "wayland") {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  services.displayManager.sessionPackages = [pkgs.hyprland];
}
