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

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  programs.zsh.enable = true;
  users.users."${username}" = {
    shell = pkgs.zsh;
    extraGroups = [ "docker" ];
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
  age.secrets = {
    anthropic_api_secret = {
      file = ../secrets/anthropic_apikey.age;
      path = "/home/${username}/.secrets/anthropic_apikey";
      mode = "644";
    };
  };
}
