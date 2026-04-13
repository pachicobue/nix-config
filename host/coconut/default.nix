{ delib, ... }:
delib.host {
  name = "coconut";
  system = "x86_64-linux";
  rice = "catppuccin-mocha";

  myconfig = { ... }: {
    host.desktop = "wayland";
    host.network = {
      useDhcp = true;
      iface = {
        name = "eno1";
        mac = "08:bf:b8:a5:74:f7";
        enableWol = true;
      };
    };
    audio.enable = true;
    bluetooth.enable = true;
    tailscale.enable = true;
    openssh.enable = true;
    ddc.enable = true;
    fcitx.enable = true;
    nvidia.enable = true;
    gaming.enable = true;
    wakeonlan.enable = true;
    usb.enable = true;
    yubikey.enable = true;
    regreet.enable = true;
    "wm.niri".enable = true;
    alacritty.enable = true;
    helix.enable = true;
    firefox.enable = true;
    discord.enable = true;
    "claude-code".enable = true;
    mako.enable = true;
    fuzzel.enable = true;
    zathura.enable = true;
    jq.enable = true;
    "noctalia-shell".enable = true;
  };

  nixos = { ... }: {
    system.stateVersion = "25.05";
    networking.hostName = "coconut";
    nixpkgs.config.allowUnfree = true;

    boot = {
      loader = {
        grub.enable = false;
        systemd-boot.enable = false;
        limine = {
          enable = true;
          efiSupport = true;
          efiInstallAsRemovable = true;
          maxGenerations = 10;
        };
        timeout = 3;
      };
      tmp.cleanOnBoot = true;
      # aarch64バイナリをQEMUでエミュレーション（Raspberry Pi用ビルドのため）
      binfmt.emulatedSystems = [ "aarch64-linux" ];
    };

    # SSH経由でもsystemctl suspendを実行可能にする
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.login1.suspend" &&
            subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';
  };

  home = { ... }: {
    home.stateVersion = "25.05";
    programs.helix.defaultEditor = true;
  };
}
