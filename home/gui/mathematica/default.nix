{ pkgs, ... }:
{
  home.packages = [
    (pkgs.mathematica.override {
      source = pkgs.requireFile {
        name = "Wolfram_14.2.0_LIN_Japanese_Bndl.sh";
        sha256 = "sha256:0b9czf1w8wxdgh81cp3ylv4ynjr0vi2isflq8683x0nbbbf31m98";
        message = ''
          Your override for Mathematica includes a different src for the installer,
          and it is missing.
        '';
        hashMode = "recursive";
      };
    })
  ];
}
