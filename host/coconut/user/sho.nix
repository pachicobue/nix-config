{
  hostname,
  username,
}: {...}: {
  imports = [
    ../../../module/home/common.nix
    ../../../module/home/common-wayland.nix
    ../../../module/home/hyprland.nix

    ../../../module/home/cava.nix
    ../../../module/home/spotify.nix
    ../../../module/home/alacritty.nix
    ../../../module/home/firefox.nix
    ../../../module/home/obsidian.nix
    ../../../module/home/zed.nix
    ../../../module/home/discord.nix
    ../../../module/home/proton-pass.nix
    ../../../module/home/udiskie.nix
    ../../../module/home/ai.nix

    ## Installer not placed in repository. Place&Install manually!
    # ../../../module/home/mathematica.nix
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
}
