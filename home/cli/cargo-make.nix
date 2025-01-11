{ pkgs, ... }:
{
  home.file = {
    ".config/config.toml" = {
      text = ''
        search_project_root = true
      '';
    };
  };
  home.packages = [
    pkgs.cargo-make
  ];
}
