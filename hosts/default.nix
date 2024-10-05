inputs:
let
  mkNixosSystem = 
  {
    system,
    hostname,
    username,
    modules,  
  }:
  inputs.nixpkgs.lib.nixosSystem {
    inherit system modules;
    specialArgs = {
      inherit inputs hostname username;  
    };
  };
in
{
  nixos = {
    desktop = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "nixos-desktop";
      username = "sho";
      modules = [ ./desktop/configuration.nix ];
    };
  };
}  
