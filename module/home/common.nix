{
  config,
  pkgs,
  ...
}: {
  home.stateVersion = "25.05";
  home.shellAliases = {
    e = "$EDITOR";
    rm = "rm -i";
    cp = "cp -i";
  };
  xdg.userDirs = {
    enable = true;
    download = "${config.home.homeDirectory}/Download";
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Document";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Picture";
    videos = "${config.home.homeDirectory}/Video";
  };

  imports = [
    ./common/atuin.nix
    ./common/bat.nix
    ./common/btop.nix
    ./common/carapace.nix
    ./common/fd.nix
    ./common/git.nix
    ./common/helix.nix
    ./common/lsd.nix
    ./common/pueue.nix
    ./common/ripgrep.nix
    ./common/starship.nix
    ./common/zathura.nix
    ./common/zsh.nix
    ./common/zoxide.nix
  ];
  home.packages = with pkgs; [
    procs
    scooter
    ouch
    manix
  ];
}
