{
  commonConfig,
  pkgs,
  ...
}: {
  programs = {
    jujutsu = {
      enable = true;
      settings = {
        signing = {
          behavior = "drop";
          backend = "gpg";
          key = commonConfig.gpg;
        };
        git = {
          "sign-on-push" = true;
        };
        user = {
          name = "pachicobue";
          email = commonConfig.userEmail;
        };
      };
    };
  };
  home.packages = [
    pkgs.lazyjj
  ];
}
