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

  # Polkit agent
  security.soteria.enable = true;

  # Register niri-session for display managers
  services.displayManager.sessionPackages = [pkgs.niri];
}
