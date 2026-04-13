{ delib, pkgs, ... }:
delib.module {
  name = "nixos.user";
  nixos.always = { myconfig, ... }: let
    constants = myconfig.constants;
  in {
    users = {
      mutableUsers = false;

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
  };
}
