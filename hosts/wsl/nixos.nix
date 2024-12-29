args: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/fonts.nix
  ];

  users.users."${args.username}" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
  };

  # Don't touch this
  system.stateVersion = "24.05";
}
