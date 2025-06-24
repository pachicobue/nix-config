{ ... }:
{
  system.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      trusted-public-keys = [
        "pachicobue-nixos-config.cachix.org-1:m5XVNaZT8j+Wf25STEabE+wq4Ro6FMoOgwNRID0XDf8="
      ];
      substituters = [
        "https://pachicobue-nixos-config.cachix.org"
      ];
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      accept-flake-config = true;
    };
  };
}
