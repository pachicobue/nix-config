{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.git";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [git gh forgejo-cli git-credential-oauth];
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
            "http://berry:3000" = {
              helper = ["cache --timeout=7200" "oauth"];
              oauthClientId = "a4792ccc-144e-407e-86c9-5e7d8d9c3269";
              oauthAuthURL = "/login/oauth/authorize";
              oauthTokenURL = "/login/oauth/access_token";
            };
          };
        };
      };
      lazygit = {
        enable = true;
      };
    };
  };
}
