{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      clang-tools
      vscode-langservers-extracted
      lua-language-server
      markdown-oxide
      nil
      nixfmt-rfc-style
      taplo
      pkgs.rust-analyzer
      pkgs.rustfmt
    ];
    settings = {
      editor = {
        middle-click-paste = false;
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
          C-x = {
            C-s = ":write";
            k = ":buffer-close";
          };
          j.k = "normal_mode";
        };
        normal = {
          C-tab = ":buffer-next";
          C-x = {
            C-s = ":write";
            k = ":buffer-close";
          };
          H = ":buffer-previous";
          L = ":buffer-next";
          space = {
            w = ":write";
            W = ":write-all";
            f = "file_picker";
            F = "file_picker_in_current_directory";
            "." = "file_picker_in_current_buffer_directory";
            x = ":buffer-close";
            X = ":buffer-close!";
            o = ":buffer-close-others";
            O = ":buffer-close-others!";
            q = ":quit";
            Q = ":quit!";
            "space" = "command_mode";
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
        }
        {
          name = "rust";
          auto-format = true;
          formatter = {
            command = "rustfmt";
          };
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
