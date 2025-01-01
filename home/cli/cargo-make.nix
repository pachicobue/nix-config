{ pkgs, ... }:
{
  home.packages = [
    pkgs.cargo-make
  ];
}
