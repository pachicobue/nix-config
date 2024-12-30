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
  version = "unstable-2021-11-20";
  src = fetchFromGitHub {
    owner = "kawarimidoll";
    repo = "gh-q";
    rev = "5dc627f350902e0166016a9dd1f9479c75e3f392";
    hash = "sha256-A0xYze0LCA67Qmck3WXiUihchLyjbOzWNQ++mitf3bk=";
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
    description = "A gh extension to clone GitHub repositories using fzf and ghq.";
    homepage = "https://github.com/kawarimidoll/gh-q";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "gh-q";
    platforms = platforms.all;
  };
}
