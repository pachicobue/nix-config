{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.zed-editor";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
    };

  home.ifEnabled = {
    programs.zed-editor = {
      enable = true;
      installRemoteServer = true;
      mutableUserSettings = true;
      userSettings = {
        code_lens = "on";
        current_line_highlight = "gutter";
        scroll_beyond_last_line = "off";
        helix_mode = true;
        assistant = {
          enabled = true;
          version = "2";
          default_model = {
            provider = "anthropic";
            model = "claude-sonnet-4-20250514";
          };
        };
      };
      extensions = [
        "basher"
        "nix"
        "toml"
        "make"
        "typst"
        "just"
        "nu"
        "pylsp"
        "neocmake"
        "lean"
      ];
    };

    home.packages = with pkgs; [
      bash-language-server
      neocmakelsp
      just-lsp
      lean
      nixd
      nil
      python314Packages.python-lsp-server
      taplo
      tinymist
    ];
  };
}
