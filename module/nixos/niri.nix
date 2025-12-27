{
  inputs,
  pkgs,
  lib,
  hostConfig,
  ...
}:
lib.mkIf (hostConfig.desktop == "wayland") {
  nixpkgs.overlays = [inputs.niri-flake.overlays.niri];
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  # Register niri-session for display managers
  services.displayManager.sessionPackages = [pkgs.niri];
}
