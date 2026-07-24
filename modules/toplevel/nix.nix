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
          # berry上のatticd (公開キャッシュ、pullは無認証)
          "http://berry:8080/nix-config"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
          # TODO: 初回CI実行後、`attic cache info nix-config`の出力にある
          # Public Keyの値をここに追加する (例: "nix-config:XXXXXXXX=")
        ];
        accept-flake-config = true;
      };
    };
  };
}
