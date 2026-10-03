{
  delib,
  inputs,
  ...
}:
delib.overlayModule {
  name = "default";
  targets = ["nixos" "home"];
  overlays = [
    inputs.llm-agent.overlays.shared-nixpkgs
  ];
}
