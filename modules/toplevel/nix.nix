{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "nix";

  nixos.always = {
    programs.nix-ld.enable = true;
    nix = {
      package = pkgs.nixVersions.latest;
      settings = {
        fallback = true;
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];
        trusted-users = ["root" "@wheel"];
        substituters = [
          "https://nix-community.cachix.org"
          "https://helix.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        ];
        accept-flake-config = true;
      };
    };
  };
}
