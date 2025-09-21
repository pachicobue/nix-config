{hostName}: {
  pkgs,
  inputs,
  ...
}: {
  # Host name
  networking.hostName = hostName;

  # System modules
  imports = [
    inputs.nixos-wsl.nixosModules.default

    ../../module/nixos/common.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  # WSL Configuration
  wsl.enable = true;
  wsl.defaultUser = "sho";
  wsl.interop.includePath = false;

  # Register Users
  programs.zsh.enable = true;
  users = {
    users.sho = {
      isNormalUser = true;
      group = "sho";
      extraGroups = [
        "wheel"
      ];
      shell = pkgs.zsh;
    };
    groups.sho = {};
  };
}
