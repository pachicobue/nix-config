{
  inputs,
  commonConfig,
  hostConfig,
  ...
}: {
  containers = {
    jellyfin = {
      autoStart = true;
      bindMounts = {
        "/etc/ssh/ssh_host_ed25519_key" = {
          isReadOnly = true;
        };
      };
      config = {...}: {
        system.stateVersion = "${hostConfig.stateVersion.nixos}";
        age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        imports = [
          inputs.agenix.nixosModules.default
          ../../container/filebrowser.nix
        ];
      };
      specialArgs = {
        inherit commonConfig;
        inherit hostConfig;
      };
    };
    miniflux = {
      autoStart = true;
      bindMounts = {
        "/etc/ssh/ssh_host_ed25519_key" = {
          isReadOnly = true;
        };
      };
      config = {...}: {
        system.stateVersion = "${hostConfig.stateVersion.nixos}";
        age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        imports = [
          inputs.agenix.nixosModules.default
          ../../container/miniflux.nix
        ];
      };
      specialArgs = {
        inherit commonConfig;
        inherit hostConfig;
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8080 # miniflux
      8081 # filebrowser
      8096 # jellyfin
    ];
  };
}
