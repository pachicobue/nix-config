{hostname}: {inputs, ...}: let
  users = ["sho"];

  perUserHmModules = builtins.listToAttrs (map (username: {
      name = username;
      value = import ./user/${username}.nix {
        inherit hostname;
        inherit username;
      };
    })
    users);
in {
  # NixOS configs
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
    inputs.disko.nixosModules.disko
    (import ./configuration.nix {inherit hostname;})
  ];
  # Per user HM configs
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = perUserHmModules;
    extraSpecialArgs = {inherit inputs;};
  };
}
