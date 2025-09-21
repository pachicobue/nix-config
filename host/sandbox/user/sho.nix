{
  hostName,
  userName,
}: {...}: {
  imports = [
    ../../../module/home/common.nix
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
}
