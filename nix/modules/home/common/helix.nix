{ inputs, pkgs, ... }:
{
  catppuccin.helix = {
    enable = true;
    useItalics = true;
  };
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.helix;
    extraPackages = with pkgs; [
      bash-language-server
      clang-tools
      vscode-langservers-extracted
      lua-language-server
      markdown-oxide
      tinymist
      typstyle
      dhall-lsp-server
      texlab
      nil
      nixfmt-rfc-style
      taplo
      ruff
      pyright
      rust-analyzer
      rustfmt
      haskell-language-server
    ];
    settings = {
      editor = {
        middle-click-paste = false;
        completion-trigger-len = 4;
        bufferline = "always";
        color-modes = true;
        true-color = true;
        undercurl = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        whitespace.render = {
          space = "none";
          nbsp = "all";
          nnbsp = "all";
          tab = "all";
          newline = "none";
          tabpad = "none";
        };
        indent-guides.render = true;
      };
      keys = {
        insert = {
          "ｊ"."ｋ" = [
            ":sh fcitx5-remote -c"
            "normal_mode"
          ];
          j.k = [
            ":sh fcitx5-remote -c"
            "normal_mode"
          ];
        };
        normal = {
          H = ":buffer-previous";
          L = ":buffer-next";
          space = {
            w = ":write";
            W = ":write-all";
            f = "file_picker";
            "." = "file_picker_in_current_buffer_directory";
            x = ":buffer-close";
            X = ":buffer-close!";
            q = ":quit";
            Q = ":quit!";
          };
        };
      };
    };
    languages = {
      language = [
        {
          name = "cpp";
          auto-format = true;
          formatter = {
            command = "clang-format";
          };
          language-servers = [
            "clangd"
          ];
        }
        {
          name = "rust";
          auto-format = true;
          formatter = {
            command = "rustfmt";
          };
          language-servers = [
            "rust-analyzer"
          ];
        }
        {
          name = "python";
          auto-format = true;
          language-servers = [
            "ruff"
            "pyright"
          ];
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixfmt";
            args = [ "-" ];
          };
        }
        {
          name = "toml";
          auto-format = true;
          formatter = {
            command = "taplo";
            args = [
              "format"
              "-"
            ];
          };
        }
      ];
    };
  };
}
