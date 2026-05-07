{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "user.nix";

  nixos.always = {myconfig, ...}: let
    inherit (myconfig.constants) rootPassHash userPassHash userName userFullName;
  in {
    # User設定
    users = {
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
      groups.${userName} = {};
    };
    programs = {
      zsh.enable = true; # 明示的にshellをインストールすること！
    };
  };

  home.always = {myconfig, ...}: let
    inherit (myconfig.constants) userName;
  in {
    home = {
      username = userName;
      homeDirectory = "/home/${userName}";
    };
  };
}
