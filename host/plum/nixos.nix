{
  inputs,
  commonConfig,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default

    ../../module/nixos/common.nix

    ../../module/nixos/yubikey.nix
  ];

  # WSL Configuration
  wsl.enable = true;
  wsl.defaultUser = commonConfig.userName;
  wsl.interop.includePath = false;
}
