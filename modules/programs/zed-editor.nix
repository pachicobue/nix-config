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
      mutableUserSettings = false;
      userSettings = {
        base_keymap = "None";
        code_lens = "on";
        current_line_highlight = "gutter";
        scroll_beyond_last_line = "off";
        helix_mode = true;
      };
      extraPackages = with pkgs; [
        bash-language-server
        neocmakelsp
        just-lsp
        lean
        nil
        python314Packages.python-lsp-server
        taplo
        tinymist
      ];
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
  };
}
