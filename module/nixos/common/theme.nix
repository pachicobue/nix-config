{
  inputs,
  lib,
  pkgs,
  hostConfig,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = lib.mkMerge [
    {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    }
    (
      lib.mkIf (hostConfig.desktop != "none")
      {
        image = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-nineish-catppuccin-mocha-alt.png";
          sha256 = "0cjyvc3hqyn9mw3wrx9w2cv85349gb2xdf45fj1yvj28h9jfn42f";
        };
        polarity = "dark";
        cursor = {
          package = pkgs.catppuccin-cursors.mochaMauve;
          name = "catppuccin-mocha-mauve-cursors";
          size = 24;
        };
      }
    )
  ];
}
