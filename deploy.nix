{inputs, ...}: let
  lib = inputs.nixpkgs.lib;
  self = inputs.self;
  deploy-rs = inputs.deploy-rs;
  deployConfigs =
    lib.filterAttrs
    (_: cfg: cfg.config.myconfig.deploy.enable or false)
    self.outputs.nixosConfigurations;
in {
  autoRollback = true;
  magicRollback = true;
  nodes =
    lib.mapAttrs (name: cfg: {
      hostname = name;
      profiles.system = {
        sshUser = "root";
        path = deploy-rs.lib.${cfg.pkgs.stdenv.hostPlatform.system}.activate.nixos cfg;
      };
    })
    deployConfigs;
}
