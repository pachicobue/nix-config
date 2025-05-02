{ ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/Pictures/nixos-wallpaper-catppuccin-mocha.png"
      ];
      wallpaper = ", ~/Pictures/nixos-wallpaper-catppuccin-mocha.png";
    };
  };
}
