{
  hostname,
  username,
}: {
  inputs,
  pkgs,
  ...
}: {
  # Home Manager modules
  imports = [
    ../../../module/home/common.nix
  ];
}