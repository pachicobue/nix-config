{...}: {
  imports = [
    ../../module/home/common.nix

    ../../module/home/alacritty.nix
    ../../module/home/helix.nix
    ../../module/home/firefox.nix
    ../../module/home/discord.nix
    ../../module/home/ai.nix

    # ../../../module/home/hyprland.nix
    ../../module/home/niri.nix
    ../../module/home/mako.nix
    ../../module/home/fuzzel.nix
    ../../module/home/zathura.nix

    ## Installer not placed in repository. Place&Install manually!
    # ../../../module/home/mathematica.nix
  ];
  programs.helix.defaultEditor = true;
}
