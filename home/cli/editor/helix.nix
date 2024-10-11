{ lib, pkgs, ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      theme = lib.mkDefault "catppuccin_mocha";
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
        insert.j.k = "normal_mode";
        normal = {
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
  };
}
