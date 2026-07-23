{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.git";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [git gh forgejo-cli];
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
          credential = {
            "https://github.com".helper = "!gh auth git-credential";
          };
        };
      };
      lazygit = {
        enable = true;
      };
    };
  };
}
