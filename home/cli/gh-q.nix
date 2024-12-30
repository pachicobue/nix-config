{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  ghq,
  fzf,
  ...
}:
let
  binPath = lib.makeBinPath ([
    ghq
    fzf
  ]);
in
stdenvNoCC.mkDerivation {
  pname = "gh-q";
  version = "unstable-2024-09-01";
  src = fetchFromGitHub {
    owner = "HikaruEgashira";
    repo = "gh-q";
    rev = "2a866956e06de61be45a6d12352d1a98c249ad80";
    hash = "sha256-+W6UEhxB97KaBMqAodkRA9SCx8hgDlMl/finesvlNcw=";
  };
  nativeBuildInputs = [
    makeWrapper
  ];
  installPhase = ''
    install -D -m755 "gh-q" "$out/bin/gh-q"
  '';
  postFixup = ''
    wrapProgram "$out/bin/gh-q" --prefix PATH : "${binPath}"
  '';
  meta = with lib; {
    description = "Rewrite ghq";
    homepage = "https://github.com/HikaruEgashira/gh-q";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "gh-q";
    platforms = lib.platforms.all;
  };
}
