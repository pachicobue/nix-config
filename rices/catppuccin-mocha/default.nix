{
  delib,
  pkgs,
  ...
}:
delib.rice {
  name = "catppuccin-mocha";
  inherits = ["base"];

  nixos = {...}: {
    stylix = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      polarity = "dark";
      cursor = {
        package = pkgs.catppuccin-cursors.mochaMauve;
        name = "catppuccin-mocha-mauve-cursors";
        size = 24;
      };
    };
  };
}
