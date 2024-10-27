{ lib, pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
    extraPackages = epkgs: with epkgs; [
      # Package Manager
      setup
      # Appearance
      ef-themes
      dimmer
      moody
      nano-modeline
      minions
      mlscroll
      nyan-mode
      nerd-icons
      nerd-icons-corfu
      spacious-padding
      perfect-margin
      # File Manager
      treemacs
      treemacs-nerd-icons
      treemacs-icons-dired
      treemacs-magit
      activities
      diff-hl
      # Mini Buffer
      vertico
      vertico-posframe
      consult
      consult-dir
      consult-flycheck
      consult-eglot
      embark-consult
      marginalia
      orderless
      embark
      # Editting
      meow
      vundo
      corfu
      corfu-terminal
      cape
      prescient
      puni
      which-key
      visual-regexp
      # Highlight
      rainbow-mode
      rainbow-delimiters
      hl-todo
      # Language
      reformatter
      (treesit-grammars.with-grammars
        (p:
          with p; [
            tree-sitter-bash
            tree-sitter-c
            tree-sitter-cpp
            tree-sitter-css
            tree-sitter-scss
            tree-sitter-elisp
            tree-sitter-html
            tree-sitter-javascript
            tree-sitter-json
            tree-sitter-make
            tree-sitter-markdown
            tree-sitter-markdown-inline
            tree-sitter-nix
            tree-sitter-python
            tree-sitter-rust
            tree-sitter-toml
            tree-sitter-tsx
            tree-sitter-typescript
            tree-sitter-yaml
          ]))
      eglot
      aggressive-indent
      eros
      markdown-mode
      nix-ts-mode
      org-bullets
      org-side-tree
      rust-mode
      cargo
      # Linting
      flycheck
      # Version Control
      magit
      magit-file-icons
      difftastic
      # Develop Environment
      envrc
    ];
    extraConfig = lib.readFile ./init.el;
  };
  services.emacs = {
    enable = true;
    client.enable = true;
  };
}
