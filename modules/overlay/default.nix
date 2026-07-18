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
    inputs.niri-flake.overlays.niri
    inputs.noctalia-shell.overlays.default
    inputs.llm-agent.overlays.shared-nixpkgs
  ];
}
