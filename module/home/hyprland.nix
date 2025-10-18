{pkgs, ...}: {
  imports = [
    ./hyprland/config.nix
    ./hyprland/keybind.nix
    ./hyprland/hyprpanel.nix
    ./hyprland/hyprpolkitagent.nix

    ./fuzzel.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # Avoid conflict with UWSM
  };
  home.packages = with pkgs; [
    hyprshot
  ];
}
