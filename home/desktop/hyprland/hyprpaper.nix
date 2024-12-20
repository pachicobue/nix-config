{ ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/Pictures/NixOS-Gradient-grey.png"
        "~/Pictures/nix-wallpaper-simple-dark-gray.png"
        "~/Pictures/nixos-wallpaper-catppuccin-mocha.png"
      ];
      wallpaper = ", ~/Pictures/nixos-wallpaper-catppuccin-mocha.png";
    };
  };
}
