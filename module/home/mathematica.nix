{ pkgs, ... }:
{
  home.packages = [
    (pkgs.mathematica.override {
      source = pkgs.requireFile {
        name = "Wolfram_14.2.1_LIN_Japanese_Bndl.sh";
        sha256 = "sha256:0lrsbl66wy8kzly1wl8hq2cicjimsszr2l75xvci0vvp42g8rdaa";
        message = ''
          Your override for Mathematica includes a different src for the installer,
          and it is missing.
        '';
        hashMode = "recursive";
      };
    })
  ];
}
