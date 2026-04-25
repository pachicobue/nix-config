{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "languages";
  options = with delib;
    moduleOptions {
      enable = readOnly (boolOption host.languageFeatured);
      # TODO: language-servers and formatters (WIP)
    };
  home.ifEnabled = {
    home.packages = with pkgs; [
      clang-tools
      nil
      alejandra
      taplo
      ruff
      python3Packages.jedi-language-server
      rust-analyzer
      rustfmt
    ];
  };
}
