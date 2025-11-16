{
  inputs,
  commonConfig,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default

    ../../module/nixos/common.nix
    ../../module/nixos/usb.nix
    # ../../module/nixos/netbird-client.nix
    # ../../module/nixos/tailscale.nix
  ];

  # WSL Configuration
  wsl = {
    enable = true;
    defaultUser = commonConfig.userName;
  };
}
