{
  delib,
  host,
  inputs,
  lib,
  ...
}:
delib.module {
  name = "agenix-rekey";

  options = with delib;
    moduleOptions {
      hostPubkey = strOption "";
      identityPath = pathOption "/etc/ssh/ssh_host_ed25519_key";
      secrets = listOfOption str [];
      secretPaths = attrsOfOption path {};
    };

  myconfig.always = {cfg, ...}: {
    agenix-rekey.secretPaths = lib.genAttrs cfg.secrets (name: "/run/agenix/${name}");
  };

  nixos.always = {cfg, ...}: {
    imports = [
      inputs.agenix.nixosModules.default
      inputs.agenix-rekey.nixosModules.default
    ];
    age.identityPaths = [cfg.identityPath];
    age.rekey = {
      hostPubkey = cfg.hostPubkey;
      masterIdentities = [
        ../../secrets/yubikey-identity.pub
        {
          identity = ../../secrets/master-identity.age;
          pubkey = "age1twrwu7sekfn7v7setmryn6dajs77sd6ljk574u8wkhjxpt2yfpsqguv7e9";
        }
      ];
      storageMode = "local";
      localStorageDir = ../../secrets/rekeyed + "/${host.name}";
    };
    age.secrets = lib.genAttrs cfg.secrets (name: {
      rekeyFile = ../../secrets + "/${name}.age";
    });
  };
}
