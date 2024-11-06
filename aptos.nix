{ stdenv, fetchurl, lib, unzip }:

let
  os =
    if stdenv.isLinux then "Ubuntu-22.04"
    else throw "Unsupported platform ${stdenv.system}";

  sha256 = "sha256-k0vpB2TzFWiW4C/e6OYXQoje1CN1smhZ97EK+Jj1eRk=";

in stdenv.mkDerivation rec {
  pname = "aptos-cli";
  version = "4.3.0";

  src = fetchurl {
    url = "https://github.com/aptos-labs/aptos-core/releases/download/${pname}-v${version}/${pname}-${version}-${os}-x86_64.zip";
    sha256 = sha256;
  };

  buildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp aptos $out/bin/aptos
  '';

  meta = with lib; {
    description = "Aptos CLI";
    homepage = "https://github.com/aptos-labs/aptos-core";
    platforms = [ "x86_64-darwin" "aarch64-darwin" "x86_64-linux" "aarch64-linux" ];
  };
}
