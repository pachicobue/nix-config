{ ... }:
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    # clearDefaultKeybinds = true;
    settings = {
      font-family = "Moralerspace Neon NF";
      font-size = 12;
      window-padding-x = 10;
      window-padding-y = 5;
      window-padding-balance = true;
      background-opacity = 0.8;
      background-blur = 20;
    };
  };
}
