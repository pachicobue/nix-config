{
  delib,
  inputs,
  pkgs,
  ...
}:
delib.rice {
  name = "base";
  inheritanceOnly = true;

  nixos = {...}: {
    imports = [inputs.stylix.nixosModules.stylix];
    stylix = {
      enable = true;
      icons = {
        enable = true;
        package = pkgs.adwaita-icon-theme;
        light = "Adwaita";
        dark = "Adwaita";
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
          package = pkgs.moralerspace-jpdoc;
          name = "Moralerspace Neon JPDOC";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
        sizes = let
          size = 12;
        in {
          applications = size;
          desktop = size;
          popups = size;
          terminal = size;
        };
      };
    };
  };

  home = {...}: {
    stylix = {
      targets.firefox.profileNames = ["default"];
      targets.zen-browser.profileNames = ["default"];
    };
  };
}
