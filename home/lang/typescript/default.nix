{ pkgs, ... }:
{
  home.packages = with pkgs; [
    javascript-typescript-langserver
    dprint
  ];
}
