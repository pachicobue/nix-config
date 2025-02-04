{ pkgs, ... }:
{
  home.packages = with pkgs; [
    typst
    marp-cli
  ];
}
