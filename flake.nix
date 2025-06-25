{
  description = "Pachicobue's Nix OS configurations.";

  # Add all your dependencies here
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blueprint = {
      url = "github:numtide/blueprint";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:yaxitech/ragenix";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    catppuccin.url = "github:catppuccin/nix";
    helix.url = "github:helix-editor/helix";

    my-nix-secret = {
      url = "git+ssh://git@github.com/pachicobue/nix-secret.git?shallow=1";
      flake = false;
    };
  };

  # Load the blueprint
  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;
      prefix = "nix/";
    };
}
