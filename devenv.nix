{
  pkgs,
  inputs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
in {
  packages = with pkgs; [
    nh
    helix
    python3Minimal
    rage

    inputs.disko.packages.${system}.disko
    # カレントのflakeに対して `nix run .#agenix-rekey.<system>.<cmd>` を叩くCLI
    # (flake側のagenix-rekey.flakeModuleが出力するappsを利用する)
    inputs.agenix-rekey.packages.${system}.default
  ];

  # Python script wrappers - Top-level APIs
  scripts.switch.exec = ''
    python3 "$DEVENV_ROOT/scripts/switch.py" "$@"
  '';

  env.NIX_CONFIG = "extra-experimental-features = nix-command flakes";
}
