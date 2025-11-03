{
  description = "Pachicobue's Nix OS configurations.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my-nix-secret = {
    #   url = "github:pachicobue/nix-secret";
    #   flake = false;
    # };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: let
    common = {
      userName = "sho";
      userFullName = "Sho Yasui";
      userEmail = "github.ranch301@passmail.net";
      userPassHash = "$y$jFT$8ucjYlvf80e0wuuTIRCST.$w4/ZC0ZCsas0nq3vxghytE9cwLORY5ioE6hc1zz3Ph4";
      rootPassHash = "$y$jFT$RxsQil2C/9qnFX4LcUD9S1$.8fXwaf9oMzCVHV2v/NyaavHgk8h3oBk.HfsFRYWLH5";
      sshKeys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFNr0LUHwXLsJ2PatYjqGmI0ysEQDeDwlmde1qE+JAEOAAAAB3NzaDpzaG8= yubikey5"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJMh1WWX6JlHyzTp+oyn7iGO4+lcDFnZvtqXdDARcxyzAAAAB3NzaDpzaG8= yubikey5C"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJGjzlH+kjBX98qiZOQ1raIQ2H6CJefEq3c8LO4uSuP sho@coconut"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIurSBgviLvpzHnZOMuu7UEbw9sktSuVahUySjW0dquy sho@plum"
      ];
      u2fMappings = [
        ":Dbvc/UKxa67YXHnT2UHFxz5+2uJ+nSlJIlxFVkuUbm2QMuRaCt5CMryJISviqZE52VzT0KmBawjVqFZBHFxvLA==,IZNkn3O8uUZgFvE4dftrcXkIa/qMWsSkP/9Btw4VSE028Ps2nQ7BIUs382LBopylCW9ctJ9W6LCeX8sV1usgZw==,es256,+presence"
        ":4gggXi9HjEIbpw65Jr3jRhls/GKa+sRGfbegDG5KKrIBf4WoPVzCa+Huc8U5gQDX6N4m+vgH6eH87cwv9RLecg==,fORR3/Imh08tiT7R96Y4qJALqSgErH5mYjnxI02yqHpW+3IZb7y9D66r7AkRbMULlf/LK+ukqjyTsUw3JT2GAQ==,es256,+presence"
      ];
      network = {
        gateway = "192.168.10.1";
        dns = [
          "192.168.10.181"
          "1.1.1.1"
        ];
      };
    };
    hosts = [
      {
        name = "coconut";
        system = "x86_64-linux";
        stateVersion = {
          nixos = "25.05";
          homeManager = "25.05";
        };
        desktop = "wayland";
        network = {
          useDhcp = true;
          iface = {
            name = "eno1";
            mac = "08:bf:b8:a5:74:f7";
            enableWol = true;
          };
        };
      }
      {
        name = "plum";
        system = "x86_64-linux";
        stateVersion = {
          nixos = "25.05";
          homeManager = "25.05";
        };
        desktop = "wayland";
        network = {
          useDhcp = true;
          iface = {};
        };
      }
      {
        name = "berry";
        system = "x86_64-linux";
        stateVersion = {
          nixos = "25.05";
          homeManager = "25.05";
        };
        desktop = "none";
        network = {
          useDhcp = true;
          iface = {
            name = "enp1s0";
            mac = "68:1d:ef:37:e8:ab";
            enableWol = true;
          };
        };
      }
      {
        name = "pi4";
        system = "aarch64-linux";
        stateVersion = {
          nixos = "25.05";
          homeManager = "25.05";
        };
        desktop = "none";
        network = {
          useDhcp = false;
          iface = {
            name = "eth0";
            address = "192.168.10.181";
            mac = "2c:cf:67:1a:1c:61";
          };
        };
      }
    ];
    args = {
      inherit inputs;
      inherit common;
      inherit hosts;
    };
  in {
    nixosConfigurations = import ./nixos-configuration.nix args;
    deploy = import ./deploy.nix args;
    packages = import ./package.nix args;
    checks = import ./check.nix args;
    devShells = import ./devshell.nix args;
  };
}
