{
  inputs,
  commonConfig,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default

    ../../module/nixos/common.nix
    ../../module/nixos/netbird-client.nix
  ];

  # WSL Configuration
  wsl = {
    enable = true;
    defaultUser = commonConfig.userName;
  };
}
