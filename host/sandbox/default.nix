{hostName}: {inputs, ...}: let
  users = ["sho"];
  perUserHmModules = builtins.listToAttrs (map (userName: {
      name = userName;
      value = import ./user/${userName}.nix {
        inherit hostName;
        inherit userName;
      };
    })
    users);
in {
  # NixOS configs
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
    inputs.disko.nixosModules.disko
    (import ./configuration.nix {inherit hostName;})
  ];
  # Per user HM configs
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = perUserHmModules;
    extraSpecialArgs = {inherit inputs;};
  };
}
