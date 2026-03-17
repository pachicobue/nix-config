{
  osConfig,
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
          key = osConfig.myconfig.constants.gpg;
        };
        git = {
          "sign-on-push" = true;
        };
        user = {
          name = "pachicobue";
          email = osConfig.myconfig.constants.userEmail;
        };
      };
    };
  };
  home.packages = [
    pkgs.lazyjj
  ];
}
