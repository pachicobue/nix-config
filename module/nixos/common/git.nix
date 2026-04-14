{ delib, pkgs, ... }:
delib.module {
  name = "nixos.git";
  nixos.always.environment.systemPackages = [
    pkgs.git
    pkgs.gh
  ];
}
