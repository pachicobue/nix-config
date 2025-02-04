{
  pkgs,
  username,
  system,
  inputs,
  ...
}:
{
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "ja_JP.UTF-8";
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${system}".default
    vim
    git
  ];

  programs.zsh.enable = true;
  users.users."${username}" = {
    shell = pkgs.zsh;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
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
  nixpkgs.config.allowUnfree = true;
  age.identityPaths = [
    "/home/${username}/.ssh/id_ed25519"
  ];
}
