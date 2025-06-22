{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      clang-tools
      haskell-language-server
      vscode-langservers-extracted
      pyright
      taplo
      nixd
      nil
    ];
    extensions = [
      "catppuccin-icons"
      "nix"
    ];
    userSettings = {
      buffer_font_family = "Moralerspace Neon NF";
      buffer_font_features = {
        calt = false;
      };
      buffer_font_size = 14;
      current_line_highlight = "gutter";
      scroll_beyond_last_line = "off";
      vim_mode = true;
      vim = {
        default_mode = "helix_normal";
        use_system_clipboard = "never";
        use_multiline_find = true;
      };
      languages = {
        "C++" = {
          format_on_save = "on";
        };
        "HTML" = {
          formatter = "language_server";
        };
      };
    };
  };
}
