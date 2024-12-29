{ ... }:
let
  f = name: {
    ".config/nushell/completions/${name}" = {
      source = ./completions + "/${name}";
    };
  };
  use = name: "use ~/.config/nushell/completions/${name} *";
  completions = [
    "bat.nu"
    "btm.nu"
    "cargo-make.nu"
    "cargo.nu"
    "gh.nu"
    "git.nu"
    "nix.nu"
    "rg.nu"
    "zellij.nu"
  ];
  baseConfig = ''
    def start_zellij [] {
      if 'ZELLIJ' not-in ($env | column) {
        zellij
      }
    }
    start_zellij
  '';
in
{
  home.file = builtins.foldl' (acc: name: acc // (f name)) { } completions;
  programs.nushell = {
    enable = true;
    shellAliases = {
      rm = "rm -i";
      cp = "cp -i";
      ll = "ls -l";
      la = "ls -a";
      e = "hx";
    };
    extraConfig = builtins.foldl' (acc: name: acc + "\n" + (use name)) baseConfig completions;
  };
}
