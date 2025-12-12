{commonConfig, ...}: {
  programs = {
    git = {
      enable = true;
      signing = {
        key = commonConfig.gpg;
        signByDefault = true;
      };
      settings = {
        user = {
          name = "pachicobue";
          email = commonConfig.userEmail;
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
