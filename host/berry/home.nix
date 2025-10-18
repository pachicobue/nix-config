{...}: {
  imports = [
    ../../module/home/common.nix

    ../../module/home/helix.nix
  ];
  programs.helix.defaultEditor = true;
}
