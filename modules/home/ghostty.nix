{ ... }:
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-size = 12;
      window-padding-x = 10;
      window-padding-y = 5;
      window-padding-balance = true;
      background-opacity = 0.85;
      background-blur-radius = 20;
    };
  };
}
