{
  lib,
  hostConfig,
  ...
}:
lib.mkIf (hostConfig.desktop == "wayland") {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
}
