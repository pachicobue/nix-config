{ delib, ... }:
delib.module {
  name = "home.git";
  home.always = { myconfig, ... }: {
    programs = {
      git = {
        enable = true;
        signing = {
          key = myconfig.constants.gpg;
          signByDefault = true;
        };
        settings = {
          user = {
            name = "pachicobue";
            email = myconfig.constants.userEmail;
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
