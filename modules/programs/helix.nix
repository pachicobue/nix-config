{
  delib,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.helix";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      defaultEditor = boolOption false;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.helix = {
      enable = true;
      defaultEditor = cfg.defaultEditor;
      settings = {
        editor = {
          middle-click-paste = false;
          line-number = "relative";
          bufferline = "always";
          color-modes = true;
          jump-label-alphabet = "sadfjklewcmpgh";
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          file-picker = {
            hidden = false;
          };
          smart-tab = {
            enable = true;
          };
        };
        keys = {
          insert = {
            S-tab = "move_parent_node_start";
            j.k = ["normal_mode"];
          };
          normal = {
            tab = "move_parent_node_end";
            S-tab = "move_parent_node_start";
            H = ":buffer-previous";
            L = ":buffer-next";
            space = {
              o = "@:open <C-r>%";
              m = "@:move <C-r>%";
              w = ":write";
              W = ":write-all";
              x = ":buffer-close";
              X = ":buffer-close!";
              c = ":buffer-close-others";
              C = ":buffer-close-others!";
              q = ":quit";
              Q = ":quit!";
            };
          };
          select = {
            tab = "extend_parent_node_end";
            S-tab = "extend_parent_node_start";
          };
        };
      };

      extraPackages = with pkgs; [
        bash-language-server
        clang-tools
        neocmakelsp
        vscode-json-languageserver
        just-lsp
        lean
        marksman
        nil
        ty
        ruff
        python314Packages.python-lsp-server
        rust-analyzer
        taplo
        tinymist
        yaml-language-server

        alejandra

        lldb
      ];
      languages.language = with pkgs; [
        {
          name = "nix";
          auto-format = true;
          formatter = {command = "${lib.getExe alejandra}";};
        }
      ];
    };
  };
}
