{
  hostName,
  userName,
}: {
  inputs,
  pkgs,
  ...
}: {
  # Home Manager modules
  imports = [
    ../../../module/home/common.nix
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
}
