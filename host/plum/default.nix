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
      iface = {};
    };
  };
in
delib.host {
  name = "plum";
  system = "x86_64-linux";

  nixos = { ... }: {
    _module.args.hostConfig = hostConfig;

    home-manager.extraSpecialArgs = { inherit inputs commonConfig hostConfig; };

    imports = [
      inputs.nixos-wsl.nixosModules.default

      ../../module/nixos/common.nix
      ../../module/nixos/usb.nix
      ../../module/nixos/yubikey.nix
    ];

    system.stateVersion = hostConfig.stateVersion.nixos;
    networking.hostName = "plum";
    nixpkgs.config.allowUnfree = true;

    wsl = {
      enable = true;
      defaultUser = commonConfig.userName;
    };

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.debian.pcsc-lite.access_card" &&
            subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
      });
      polkit.addRule(function(action, subject) {
        if (action.id == "org.debian.pcsc-lite.access_pcsc" &&
            subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
      });
    '';
  };

  home = { ... }: {
    imports = [
      ../../module/home/common.nix
      ../../module/home/claude-code.nix
      ../../module/home/helix.nix
    ];

    home.stateVersion = hostConfig.stateVersion.homeManager;
    programs.helix.defaultEditor = true;
  };
}
