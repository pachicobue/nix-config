{
  delib,
  host,
  lib,
  ...
}:
delib.module {
  name = "programs.helix";
  options = with delib;
    moduleOptions {
      enable = boolOption true;
      setAsDefaultEditor = boolOption false;
    };

  myconfig.ifEnabled = {cfg, ...}: {
    commands.default.editor = lib.optional cfg.setAsDefaultEditor ["hx"];
  };
  home.ifEnabled = {cfg, ...}: {
    programs.helix = {
      enable = true;
      defaultEditor = cfg.setAsDefaultEditor;
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
            supersede-menu = true;
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
              c = "@:sh cp <C-r>% <C-r>%";
              w = ":write";
              W = ":write-all";
              x = ":buffer-close";
              X = ":buffer-close!";
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
      languages.language = lib.optionals host.languageFeatured [
        {
          name = "cpp";
          auto-format = true;
        }
        {
          name = "rust";
          auto-format = true;
        }
      ];
    };
  };
}
