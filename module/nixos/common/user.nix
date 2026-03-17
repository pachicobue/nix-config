{
  pkgs,
  config,
  ...
}: let
  constants = config.myconfig.constants;
in {
  users = {
    mutableUsers = false;

    # For deploy only
    users.root = {
      isSystemUser = true;
      initialHashedPassword = constants.rootPassHash;
      openssh.authorizedKeys.keys = constants.sshKeys;
      shell = pkgs.zsh;
    };

    users.${constants.userName} = {
      description = constants.userFullName;
      isNormalUser = true;
      initialHashedPassword = constants.userPassHash;
      extraGroups = [
        "${constants.userName}"
        "wheel"
        "video"
        "input"
        "libvirt"
        "network"
        "i2c"
      ];
      openssh.authorizedKeys.keys = constants.sshKeys;
      shell = pkgs.zsh;
    };
  };
  programs.zsh.enable = true;
}
