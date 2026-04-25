{
  delib,
  inputs,
  lib,
  ...
}:
delib.rice {
  name = "catppuccin-mocha";

  nixos = {...}: {
    imports = [inputs.stylix.nixosModules.stylix];
  };

  home = {
    myconfig,
    pkgs,
    ...
  }:
    lib.mkIf (myconfig.host.waylandFeatured || myconfig.host.x11Featured) {
      imports = [inputs.stylix.homeModules.stylix];
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        polarity = "dark";
        targets.noctalia-shell.enable = false;
        targets.firefox.profileNames = ["default"];
        sizes = {
          applications = 10;
        };
      };
    };
}
