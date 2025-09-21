{pkgs, ...}: {
  imports = [
    ./hyprland/mako.nix
  ];
  programs.fuzzel = {
    enable = true;
  };
  home.packages = with pkgs; [
    niri
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    xwayland-satellite
  ];
}
