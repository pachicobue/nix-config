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
