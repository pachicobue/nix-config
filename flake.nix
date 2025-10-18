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
      ];
      u2fMappings = [
        ":Dbvc/UKxa67YXHnT2UHFxz5+2uJ+nSlJIlxFVkuUbm2QMuRaCt5CMryJISviqZE52VzT0KmBawjVqFZBHFxvLA==,IZNkn3O8uUZgFvE4dftrcXkIa/qMWsSkP/9Btw4VSE028Ps2nQ7BIUs382LBopylCW9ctJ9W6LCeX8sV1usgZw==,es256,+presence"
        ":4gggXi9HjEIbpw65Jr3jRhls/GKa+sRGfbegDG5KKrIBf4WoPVzCa+Huc8U5gQDX6N4m+vgH6eH87cwv9RLecg==,fORR3/Imh08tiT7R96Y4qJALqSgErH5mYjnxI02yqHpW+3IZb7y9D66r7AkRbMULlf/LK+ukqjyTsUw3JT2GAQ==,es256,+presence"
      ];
    };
    hosts = [
      {
        name = "coconut";
        system = "x86_64-linux";
        stateVersion = {
          nixos = "25.05";
          homeManager = "25.05";
        };
        iface = "eno1";
        desktop = "wayland";
      }
      {
        name = "plum";
        system = "x86_64-linux";
        stateVersion = {
          nixos = "25.05";
          homeManager = "25.05";
        };
        iface = "eth0";
        desktop = "wayland";
      }
      {
        name = "berry";
        system = "x86_64-linux";
        stateVersion = {
          nixos = "25.05";
          homeManager = "25.05";
        };
        iface = "enp1s0";
        desktop = "none";
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
