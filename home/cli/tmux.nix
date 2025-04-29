{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "C-g";
    keyMode = "vi";
    clock24 = true;
    escapeTime = 0;
    terminal = "foot";
    disableConfirmationPrompt = true;
    historyLimit = 5000;
    mouse = true;
    secureSocket = false;
    aggressiveResize = true;
    customPaneNavigationAndResize = true;
    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
      prefix-highlight
    ];
    extraConfig = ''
      unbind-key -a
      bind-key r source-file ~/.config/tmux/tmux.conf\; display-message "`~/.config/tmux/tmux.conf` reloaded"
      bind-key -n C-t if-shell -F "#{==:#{session_name},floating}" {
        detach-client
      } {
        display-popup -w 80% -h 80% -E "tmux new-session -A -s floating"
      }
      set -g status-right '#{prefix_highlight}'
      set -g @prefix_highlight_show_copy_mode 'on'
      set -g @prefix_highlight_copy_mode_attr 'fg=black,bg=yellow,bold' # default is 'fg=default,bg=yellow'
      set -g @prefix_highlight_show_sync_mode 'on'
      set -g @prefix_highlight_sync_mode_attr 'fg=black,bg=green' # default is 'fg=default,bg=yellow'



    '';
  };
}
