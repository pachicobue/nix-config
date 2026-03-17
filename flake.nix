{
  description = "Pachicobue's Nix OS configurations.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    denix = {
      url = "github:yunfachi/denix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs @ { ... }: let
    # commonConfig: deploy.nix等から参照する共通設定。Phase 3でmodule/config/constants.nixへ移行予定
    commonConfig = {
      userName = "sho";
      userFullName = "Sho Yasui";
      userEmail = "mail@pachicobue.org";
      userPassHash = "$y$jFT$8ucjYlvf80e0wuuTIRCST.$w4/ZC0ZCsas0nq3vxghytE9cwLORY5ioE6hc1zz3Ph4";
      rootPassHash = "$y$jFT$RxsQil2C/9qnFX4LcUD9S1$.8fXwaf9oMzCVHV2v/NyaavHgk8h3oBk.HfsFRYWLH5";
      gpg = "E4E61C685DD58216CE33134FC743571182DA7DB9";
      sshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJGjzlH+kjBX98qiZOQ1raIQ2H6CJefEq3c8LO4uSuP sho@coconut"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIurSBgviLvpzHnZOMuu7UEbw9sktSuVahUySjW0dquy sho@plum"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9zd4/wJ4gleti/ciOfbI0wMi/lG7Rkgc9Q2jyjA7Cg iPhone XR"
      ];
      network = {
        gateway = "192.168.10.1";
        dns = "192.168.10.181";
      };
      wolHosts = [
        { name = "coconut"; mac = "08:bf:b8:a5:74:f7"; }
        { name = "berry"; mac = "68:1d:ef:37:e8:ab"; }
      ];
    };
    # hosts: deploy.nix がサーバーホストのフィルタリングに使用。Phase 5で整理予定
    hosts = [
      { name = "coconut"; system = "x86_64-linux"; desktop = "wayland"; }
      { name = "plum"; system = "x86_64-linux"; desktop = "wayland"; }
      { name = "berry"; system = "x86_64-linux"; desktop = "none"; }
      { name = "pi4"; system = "aarch64-linux"; desktop = "none"; }
    ];
    args = { inherit inputs commonConfig hosts; };
  in {
    nixosConfigurations = inputs.denix.lib.configurations {
      moduleSystem = "nixos";
      homeManagerUser = commonConfig.userName;
      paths = [ ./host ./module/config ./rice ];
      specialArgs = { inherit inputs commonConfig; };
      extensions = with inputs.denix.lib.extensions; [ base ];
    };
    deploy = import ./deploy.nix args;
    packages = import ./package.nix args;
    checks = import ./check.nix args;
    devShells = import ./devshell.nix args;
  };
}
