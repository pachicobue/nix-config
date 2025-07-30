{
  hostname,
  username,
}: {...}: {
  imports = [
    ../../../modules/home/common.nix
    ../../../modules/home/common-wayland.nix
    ../../../modules/home/hyprland.nix
    ../../../modules/home/cava.nix
    ../../../modules/home/spotify-player.nix
    ../../../modules/home/ghostty.nix
    ../../../modules/home/firefox.nix
    ../../../modules/home/obsidian.nix
    ../../../modules/home/zed.nix
    ../../../modules/home/discord.nix
    ../../../modules/home/proton-pass.nix
    ../../../modules/home/udiskie.nix
    ../../../modules/home/ai.nix

    ## Installer not placed in repository. Place&Install manually!
    # ../../../modules/home/mathematica.nix
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
}
