{inputs, ...}: {
  # nix-secret 参照
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  imports = [
    inputs.agenix.nixosModules.age
    common/font.nix
    common/console.nix
    common/nix.nix
    common/locale.nix
    common/direnv.nix
    common/theme.nix
  ];
}
