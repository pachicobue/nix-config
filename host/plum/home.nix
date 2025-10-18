{...}: {
  imports = [
    ../../module/home/common.nix

    ../../module/home/ai.nix
    ../../module/home/helix.nix
  ];
  programs.helix.defaultEditor = true;
}
