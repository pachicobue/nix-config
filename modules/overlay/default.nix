{
  delib,
  inputs,
  ...
}:
delib.overlayModule {
  name = "default";
  targets = ["nixos" "home"];
  overlays = [
    inputs.noctalia-shell.overlays.default
    inputs.llm-agent.overlays.shared-nixpkgs
  ];
}
