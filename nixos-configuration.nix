{
  inputs,
  common,
  hosts,
  ...
}: let
  nixpkgs = inputs.nixpkgs;
  home-manager = inputs.home-manager;
in
  builtins.listToAttrs (
    map (
      host: {
        name = host.name;
        value = (
          nixpkgs.lib.nixosSystem rec {
            system = host.system;
            modules = [
              home-manager.nixosModules.home-manager
              {
                system.stateVersion = host.stateVersion.nixos;
                networking.hostName = host.name;
                nixpkgs.hostPlatform = host.system;
                nixpkgs.config.allowUnfree = true;
                imports = [
                  inputs.sops-nix.nixosModules.sops
                  ./host/${host.name}/nixos.nix
                ];
              }
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  sharedModules = [
                    inputs.sops-nix.homeManagerModules.sops
                  ];
                  users.${common.userName} = {
                    home.stateVersion = host.stateVersion.homeManager;
                    imports = [
                      inputs.sops-nix.homeManagerModules.sops
                      ./host/${host.name}/home.nix
                    ];
                  };
                  extraSpecialArgs = specialArgs;
                };
              }
            ];
            specialArgs = {
              inherit inputs;
              allHostConfig = hosts;
              hostConfig = host;
              commonConfig = common;
            };
          }
        );
      }
    )
    hosts
  )
