{hostname}: {inputs, ...}: let
  users = ["sho"];

  perUserHmModules = builtins.listToAttrs (map (username: {
      name = username;
      value = import ./users/${username}.nix {
        inherit hostname;
        inherit username;
      };
    })
    users);
in {
  # NixOS configs
  imports = [
    ./hardware-configuration.nix
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
