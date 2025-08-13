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
