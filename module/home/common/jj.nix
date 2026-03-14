{
  pkgs,
  commonConfig,
  ...
}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "pachicobue";
        email = commonConfig.userEmail;
      };
    };
  };
  home.packages = [pkgs.jjui];
}
