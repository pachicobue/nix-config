{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    clock24 = true;
    disableConfirmationPrompt = true;
    historyLimit = 5000;
    mouse = true;
    secureSocket = false;
    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
      prefix-highlight
    ];
  };
}
