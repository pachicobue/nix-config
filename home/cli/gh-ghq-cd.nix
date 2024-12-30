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
  pname = "gh-ghq-cd";
  version = "unstable-2024-08-02";
  src = fetchFromGitHub {
    owner = "cappyzawa";
    repo = "gh-ghq-cd";
    rev = "359c24f5c99d2cdedec0d86c764edbbd868e9ea1";
    hash = "sha256-d0FwMawNriCEWW6E2AkrPWihdp6A5ttJ7NX7PAQ0iUc=";
  };
  nativeBuildInputs = [
    makeWrapper
  ];
  installPhase = ''
    install -D -m755 "gh-ghq-cd" "$out/bin/gh-ghq-cd"
  '';
  postFixup = ''
    wrapProgram "$out/bin/gh-ghq-cd" --prefix PATH : "${binPath}"
  '';
  meta = {
    description = "A gh extention for exploring the `ghq list";
    homepage = "https://github.com/cappyzawa/gh-ghq-cd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "gh-ghq-cd";
    platforms = lib.platforms.all;
  };
}
