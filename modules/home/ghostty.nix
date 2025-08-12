{...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    # clearDefaultKeybinds = true;
    settings = {
      window-padding-x = 10;
      window-padding-y = 5;
      window-padding-balance = true;
    };
  };
}
