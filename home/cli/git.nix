{ pkgs, ... }:
let
  gh-q = pkgs.stdenv.mkDerivation rec {
    name = "gh-q";
    pname = name;
    src = pkgs.fetchFromGitHub {
      owner = "HikaruEgashira";
      repo = "gh-q";
      rev = "2a866956e06de61be45a6d12352d1a98c249ad80";
      hash = "sha256-+W6UEhxB97KaBMqAodkRA9SCx8hgDlMl/finesvlNcw=";
    };
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      sed 1d $src/gh-q > $out/bin/gh-q # remove original shebang
      sed -i "1i#!\/usr\/bin\/env sh" $out/bin/gh-q # add new shebang
      chmod +x $out/bin/gh-q # make executable
    '';
  };
in
{
  programs.git = {
    enable = true;
    userName = "pachicobue";
    userEmail = "tigerssho@gmail.com";
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  programs.gh = {
    enable = true;
    package = pkgs.gh;
    extensions = [ gh-q ];
  };
}
