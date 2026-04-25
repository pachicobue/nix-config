{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.git";
  options = delib.singleEnableOption true;

  nixos.ifEnabled = {
    environment.systemPackages = [pkgs.git pkgs.gh];
  };

  home.ifEnabled = {myconfig, ...}: let
    inherit (myconfig.constants) gpg userEmail userHandleName;
  in {
    programs = {
      git = {
        enable = true;
        signing = {
          key = gpg;
          signByDefault = true;
        };
        settings = {
          user = {
            name = userHandleName;
            email = userEmail;
          };
          init.defaultBranch = "main";
          pull.rebase = true;
          credential.helper = "!gh auth git-credential";
        };
      };
      lazygit = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
