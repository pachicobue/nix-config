{inputs, ...}: let
  self = inputs.self;
  deploy-rs = inputs.deploy-rs;
in
  builtins.mapAttrs
  (system: deployLib: deployLib.deployChecks self.outputs.deploy)
  deploy-rs.lib
