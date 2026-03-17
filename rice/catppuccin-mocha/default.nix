{ delib, inputs, ... }:
delib.rice {
  name = "catppuccin-mocha";

  nixos = {
    imports = [
      inputs.stylix.nixosModules.stylix
      (
        { hostConfig, lib, ... }:
        lib.mkIf (hostConfig.desktop != "none") {
          home-manager.sharedModules = [
            inputs.stylix.homeModules.stylix
            (
              { pkgs, ... }:
              {
                stylix = {
                  enable = true;
                  base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
                  polarity = "dark";
                  targets.noctalia-shell.enable = false;
                  targets.firefox.profileNames = [ "default" ];
                };
              }
            )
          ];
        }
      )
    ];
  };
}
