{
  hostname,
  username,
}: {
  imports = [
    ../../../module/home/common.nix
    ../../../module/home/common-wayland.nix
    ../../../module/home/ai.nix
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
}
