{ ... }:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "catppuccin-icons"
      "dockerfile"
      "hyprlang"
      "jsonnet"
      "markdown-oxide"
      "nix"
      "pylsp"
      "typst"
      "haskell"
    ];
  };
}
