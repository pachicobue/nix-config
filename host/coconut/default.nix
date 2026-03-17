{ delib, inputs, commonConfig, ... }:
let
  hostConfig = {
    desktop = "wayland";
    stateVersion = {
      nixos = "25.05";
      homeManager = "25.05";
    };
    network = {
      useDhcp = true;
      iface = {
        name = "eno1";
        mac = "08:bf:b8:a5:74:f7";
        enableWol = true;
      };
    };
  };
in
delib.host {
  name = "coconut";
  system = "x86_64-linux";
  rice = "catppuccin-mocha";

  nixos = { ... }: {
    _module.args.hostConfig = hostConfig;

    home-manager.extraSpecialArgs = { inherit inputs commonConfig hostConfig; };

    imports = [
      inputs.disko.nixosModules.disko
      ../../hardware/coconut/hardware-configuration.nix
      ../../hardware/coconut/disk-config.nix

      ../../module/nixos/common.nix
      ../../module/nixos/openssh.nix
      ../../module/nixos/ddc.nix
      ../../module/nixos/fcitx.nix
      ../../module/nixos/audio.nix
      ../../module/nixos/nvidia.nix
      ../../module/nixos/gaming.nix
      ../../module/nixos/wakeonlan.nix
      ../../module/nixos/tailscale.nix
      ../../module/nixos/bluetooth.nix
      ../../module/nixos/usb.nix
      ../../module/nixos/yubikey.nix
      ../../module/nixos/wm/niri.nix
      ../../module/nixos/greetd/regreet.nix
    ];

    system.stateVersion = hostConfig.stateVersion.nixos;
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
    imports = [
      ../../module/home/common.nix

      ../../module/home/alacritty.nix
      ../../module/home/helix.nix
      ../../module/home/firefox.nix
      ../../module/home/discord.nix
      ../../module/home/claude-code.nix

      ../../module/home/wm/niri.nix
      ../../module/home/mako.nix
      ../../module/home/fuzzel.nix
      ../../module/home/zathura.nix
    ];

    home.stateVersion = hostConfig.stateVersion.homeManager;
    programs.helix.defaultEditor = true;
  };
}
