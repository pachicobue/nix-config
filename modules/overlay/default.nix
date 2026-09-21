{
  delib,
  inputs,
  ...
}:
delib.overlayModule {
  name = "default";
  targets = ["nixos" "home"];
  overlays = [
    inputs.helix.overlays.default
    inputs.noctalia-shell.overlays.default
    inputs.llm-agent.overlays.shared-nixpkgs
  ];
}
