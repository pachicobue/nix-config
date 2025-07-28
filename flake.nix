{
  description = "Pachicobue's Nix OS configurations.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    catppuccin.url = "github:catppuccin/nix";
    helix.url = "github:helix-editor/helix";

    my-nix-secret = {
      url = "git+ssh://git@github.com/pachicobue/nix-secret.git?shallow=1";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Import modules
      nixosModules = {
        common = ./modules/nixos/common.nix;
        sho = ./modules/nixos/sho.nix;
        audio = ./modules/nixos/audio.nix;
        bluetooth = ./modules/nixos/bluetooth.nix;
        fcitx = ./modules/nixos/fcitx.nix;
        gaming = ./modules/nixos/gaming.nix;
        hyprland = ./modules/nixos/hyprland.nix;
        keyboard = ./modules/nixos/keyboard.nix;
        network = ./modules/nixos/network.nix;
        nvidia = ./modules/nixos/nvidia.nix;
        plymouth = ./modules/nixos/plymouth.nix;
        udisk = ./modules/nixos/udisk.nix;
        virtualization = ./modules/nixos/virtualization.nix;
        yubikey = ./modules/nixos/yubikey.nix;
      };

      homeModules = {
        common = ./modules/home/common.nix;
        common-wayland = ./modules/home/common-wayland.nix;
        ai = ./modules/home/ai.nix;
        cava = ./modules/home/cava.nix;
        discord = ./modules/home/discord.nix;
        firefox = ./modules/home/firefox.nix;
        ghostty = ./modules/home/ghostty.nix;
        hyprland = ./modules/home/hyprland.nix;
        mathematica = ./modules/home/mathematica.nix;
        obsidian = ./modules/home/obsidian.nix;
        proton-pass = ./modules/home/proton-pass.nix;
        spotify-player = ./modules/home/spotify-player.nix;
        udiskie = ./modules/home/udiskie.nix;
        zed = ./modules/home/zed.nix;
      };

      # Common config function
      mkNixosConfig =
        {
          hostname,
          modules ? [ ],
          userHomeModules ? [ ],
          hasHardwareConfig ? true,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules =
            [
              ./hosts/${hostname}/configuration.nix
              nixosModules.sho
              nixosModules.common
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.sho = {
                    imports = [ homeModules.common ] ++ userHomeModules;
                  };
                  extraSpecialArgs = { inherit inputs; };
                };
              }
            ]
            ++ (if hasHardwareConfig then [ ./hosts/${hostname}/hardware-configuration.nix ] else [ ])
            ++ (map (name: nixosModules.${name}) modules);
        };
    in
    {
      nixosConfigurations = {
        desktop = mkNixosConfig {
          hostname = "desktop";
          modules = [
            "bluetooth"
            "udisk"
            "yubikey"
            "virtualization"
            "audio"
            "nvidia"
            "fcitx"
            "network"
            "gaming"
            "hyprland"
            "keyboard"
          ];
          userHomeModules = [
            homeModules.common-wayland
            homeModules.ai
            homeModules.cava
            homeModules.discord
            homeModules.firefox
            homeModules.ghostty
            homeModules.hyprland
            # homeModules.mathematica
            homeModules.obsidian
            homeModules.proton-pass
            homeModules.spotify-player
            homeModules.udiskie
            homeModules.zed
          ];
        };

        wsl = mkNixosConfig {
          hostname = "wsl";
          modules = [ ];
          userHomeModules = [ homeModules.ai ];
          hasHardwareConfig = false;
        };

        vm = mkNixosConfig {
          hostname = "vm";
          modules = [ "fcitx" ];
          userHomeModules = [ ];
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          git
          github-cli
          (writeScriptBin "switch" ''
            sudo nixos-rebuild switch --flake ".#$@" --show-trace
          '')
        ];
      };
    };
}
