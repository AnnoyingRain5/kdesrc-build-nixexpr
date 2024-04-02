# This piece of code goes to public domain

{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  perl5lib = perlPackages.makeFullPerlPath [ perlPackages.NetHTTPSNB perlPackages.YAMLSyck ];
in
stdenv.mkDerivation rec {
  name = "kdesrc-build";
  version = "22.07";
  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "SDK";
    repo = "kdesrc-build";
    rev = "v${version}";
    sha256 = "X+A4nMqiFrrToQ85xg5r7DLxgN+iWRIVnhZ4JzXqAi8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin/
    wrapProgram $out/bin/kdesrc-build \
                --prefix PATH : ${lib.makeBinPath [ perl ]} \
                --set PERL5LIB ${perl5lib}
    wrapProgram "$out/bin/kdesrc-build-setup" \
                --prefix PATH : ${lib.makeBinPath [ dialog perl ]}
  '';
}
