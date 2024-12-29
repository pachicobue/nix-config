args: {
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
    ../../modules/core.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "sho";

  users.users."${args.username}" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
  };

  # Don't touch this
  system.stateVersion = "24.05";
}
