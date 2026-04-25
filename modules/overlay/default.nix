{
  delib,
  inputs,
  ...
}:
delib.overlayModule {
  name = "default";
  overlays = [
    inputs.helix.overlays.default
    inputs.niri-flake.overlays.niri
    inputs.noctalia-shell.overlays.default
    inputs.llm-agent.overlays.default
  ];
}
