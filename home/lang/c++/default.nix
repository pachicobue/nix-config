{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clang-tools
    clang
    lldb
  ];

}
