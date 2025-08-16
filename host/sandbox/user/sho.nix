{
  hostname,
  username,
}: {...}: {
  imports = [
    ../../../module/home/common.nix
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
}
