{
  pkgs,
  lib,
  inputs,
  commonConfig,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default

    ../../module/nixos/common.nix

    ../../module/nixos/avahi.nix
    ../../module/nixos/netbird-client.nix
    # ../../module/nixos/yubikey.nix
  ];

  # WSL Configuration
  wsl = {
    enable = true;
    defaultUser = commonConfig.userName;
    wslConf = {
      network = {
        generateHosts = false;
        generateResolvConf = false;
      };
    };
    # usbip = {
    #   enable = true;
    # };
    # extraBin = [
    #   {src = "${lib.getExe' pkgs.coreutils-full "ls"}";}
    #   {src = "${lib.getExe' pkgs.coreutils-full "cat"}";}
    #   {src = "${lib.getExe pkgs.bash}";}
    #   {src = "${lib.getExe' pkgs.linuxPackages.usbip "usbip"}";}
    # ];
  };
}
