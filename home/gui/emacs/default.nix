{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      defaultInitFile = true;
      package = pkgs.emacs-pgtk;
      extraEmacsPackages =
        epkgs: with epkgs; [
          (treesit-grammars.with-grammars (
            p: with p; [
              tree-sitter-bash
              tree-sitter-c
              tree-sitter-c-sharp
              tree-sitter-cmake
              tree-sitter-css
              tree-sitter-scss
              tree-sitter-dockerfile
              tree-sitter-elisp
              tree-sitter-go
              tree-sitter-html
              tree-sitter-javascript
              tree-sitter-json
              tree-sitter-make
              tree-sitter-markdown
              tree-sitter-markdown-inline
              tree-sitter-nix
              tree-sitter-python
              tree-sitter-ruby
              tree-sitter-rust
              tree-sitter-toml
              tree-sitter-tsx
              tree-sitter-typescript
              tree-sitter-yaml
            ]
          ))
        ];
    };
  };

  services.emacs =
    {
    };
}
