{ pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./shell.nix
    ./virtualisation.nix
    ./flatpak.nix
  ];

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "ja_JP.UTF-8";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    helix
  ];

}
