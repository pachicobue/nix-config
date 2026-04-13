{ delib, inputs, ... }:
delib.module {
  name = "nixos.agenix";
  nixos.always = {
    imports = [ inputs.agenix.nixosModules.default ];
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
