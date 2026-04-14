{ delib, inputs, pkgs, lib, ... }:
delib.module {
  name = "wm.niri";
  options."wm.niri".enable = delib.boolOption false;
  nixos.ifEnabled = { myconfig, ... }:
    lib.mkIf (myconfig.host.desktop == "wayland") {
      nixpkgs.overlays = [ inputs.niri-flake.overlays.niri ];
      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };
      security.soteria.enable = true;
      services.displayManager.sessionPackages = [ pkgs.niri ];
    };
}
