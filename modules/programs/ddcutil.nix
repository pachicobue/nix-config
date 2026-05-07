{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ddcutil";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    home.packages = with pkgs; [ddcutil];
  };

  nixos.ifEnabled = {myconfig, ...}: let
    inherit (myconfig.constants) userName;
  in {
    hardware.i2c.enable = true;
    users.users.${userName}.extraGroups = ["i2c"];
  };
}
