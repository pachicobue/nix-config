{
  inputs,
  hosts,
  ...
}: let
  self = inputs.self;
  deploy-rs = inputs.deploy-rs;
in {
  autoRollback = true;
  magicRollback = true;
  nodes = builtins.listToAttrs (
    map
    (
      host: {
        name = host.name;
        value = {
          hostname = "${host.name}.local"; # mDNS前提
          profiles.system = {
            sshUser = "root";
            path = deploy-rs.lib.${host.system}.activate.nixos self.outputs.nixosConfigurations.${host.name};
          };
        };
      }
    )
    (builtins.filter (host: host.desktop == "none") hosts)
  );
}
