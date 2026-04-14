{ delib, ... }:
delib.module {
  name = "tailscale";
  options.tailscale.enable = delib.boolOption false;
  nixos.ifEnabled = {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "client";
    };
  };
}
