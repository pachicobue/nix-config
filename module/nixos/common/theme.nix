{
  inputs,
  pkgs,
  ...
}: let
  size = 12;
in {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-nineish-catppuccin-mocha-alt.png";
      sha256 = "0cjyvc3hqyn9mw3wrx9w2cv85349gb2xdf45fj1yvj28h9jfn42f";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
    cursor = {
      package = pkgs.catppuccin-cursors.mochaMauve;
      name = "catppuccin-mocha-mauve-cursors";
      size = 24;
    };
    fonts = {
      serif = {
        package = pkgs.noto-fonts-cjk-serif;
        name = "Noto Serif CJK JP";
      };
      sansSerif = {
        package = pkgs.noto-fonts-cjk-sans;
        name = "Noto Sans CJK JP";
      };
      monospace = {
        package = pkgs.moralerspace-nf;
        name = "Moralerspace Neon NF";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = size;
        desktop = size;
        popups = size;
        terminal = size;
      };
    };
  };
}
