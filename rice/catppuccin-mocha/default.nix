{ delib, inputs, lib, ... }:
delib.rice {
  name = "catppuccin-mocha";

  nixos = { myconfig, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];
    home-manager.sharedModules = lib.mkIf (myconfig.host.desktop != "none") [
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
  };
}
