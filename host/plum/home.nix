{...}: {
  imports = [
    ../../module/home/common.nix

    ../../module/home/claude-code.nix
    ../../module/home/helix.nix
  ];
  programs.helix.defaultEditor = true;
}
