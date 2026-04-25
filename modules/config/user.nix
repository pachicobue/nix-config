{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "user";

  nixos.always = {myconfig, ...}: let
    inherit (myconfig.constants) rootPassHash userPassHash userName userFullName;
  in {
    users = {
      groups.${userName} = {};
      users.root = {
        isSystemUser = true;
        initialHashedPassword = rootPassHash;
        shell = pkgs.zsh;
      };

      users.${userName} = {
        description = userFullName;
        isNormalUser = true;
        initialHashedPassword = userPassHash;
        extraGroups = ["wheel"];
        shell = pkgs.zsh;
      };
    };
    programs.zsh.enable = true;
  };
}
