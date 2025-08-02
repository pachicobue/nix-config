{
  hostname,
  username,
}: {
  imports = [
    ../../../modules/home/common.nix
    ../../../modules/home/ai.nix
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
}