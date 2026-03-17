{ osConfig, ... }: {
  programs = {
    git = {
      enable = true;
      signing = {
        key = osConfig.myconfig.constants.gpg;
        signByDefault = true;
      };
      settings = {
        user = {
          name = "pachicobue";
          email = osConfig.myconfig.constants.userEmail;
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
}
