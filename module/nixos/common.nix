{
  pkgs,
  lib,
  hostConfig,
  ...
}: {
  # nix-secret 参照
  # age.identityPaths = [
  #   "/etc/ssh/ssh_host_ed25519_key"
  # ];

  imports = [
    # inputs.agenix.nixosModules.age
    ./common/user.nix
    ./common/sudo.nix
    ./common/nix.nix
    ./common/network.nix
    ./common/kmscon.nix
    ./common/theme.nix
    ./common/font.nix
    ./common/zsh.nix
    ./common/git.nix
    ./common/direnv.nix
    ./common/agenix.nix
  ];

  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "ja_JP.UTF-8";
  environment = {
    shellAliases = {
      e = "$EDITOR";
      rm = "rm -i";
      cp = "cp -i";
    };
    sessionVariables = lib.mkIf (hostConfig.desktop == "wayland") {
      NIXOS_OZONE_WL = "1";
    };
    systemPackages = with pkgs;
      [
        tealdeer
        fastfetch
        procs
        ripgrep
        fd
        dust
        bottom
        sd
        tailspin
        skim
      ]
      ++ (
        if (hostConfig.desktop != "none")
        then [wl-clipboard waypipe]
        else []
      );
    # XDG Desktop Portal用（Home Manager経由でインストールする場合に必要）
    pathsToLink = lib.mkIf (hostConfig.desktop != "none") [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];
  };
}
