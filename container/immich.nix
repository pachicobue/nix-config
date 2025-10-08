{...}: {
  imports = [
    ../module/nixos/common/nix.nix
  ];
  services.immich = {
    enable = true;
  };
}
