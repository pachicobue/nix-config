{
  pkgs,
  commonConfig,
  ...
}: {
  users = {
    mutableUsers = false;

    # For deploy only
    users.root = {
      isSystemUser = true;
      initialHashedPassword = commonConfig.rootPassHash;
      openssh.authorizedKeys.keys = commonConfig.sshKeys;
      shell = pkgs.zsh;
    };

    users.${commonConfig.userName} = {
      description = commonConfig.userFullName;
      isNormalUser = true;
      initialHashedPassword = commonConfig.userPassHash;
      extraGroups = [
        "${commonConfig.userName}"
        "wheel"
        "video"
        "input"
        "libvirt"
        "network"
      ];
      openssh.authorizedKeys.keys = commonConfig.sshKeys;
      shell = pkgs.zsh;
    };
  };
  programs.zsh.enable = true;
}
