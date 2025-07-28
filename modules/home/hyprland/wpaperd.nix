{ ... }:
{
  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        path = "~/Pictures/nixos-artwork/wallpapers/";
        duration = "1m";
      };
    };
  };
}
