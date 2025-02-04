{ pkgs, ... }:
{
  home.packages = [
    pkgs.obsidian
    pkgs.chromium
  ];
}
