{ stdenv, fetchurl, lib, unzip }:

let
  os =
    if stdenv.isLinux then "Ubuntu"
    else throw "Unsupported platform ${stdenv.system}";

  sha256 = "sha256-xs3w4MuYQ8qntU+xx5zB/RFE9M9TFt/s2PZzIhDGYS4=";

in stdenv.mkDerivation rec {
  pname = "aptos-cli";
  version = "4.2.1";

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
