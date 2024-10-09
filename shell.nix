with import <nixpkgs> { };

pkgs.mkShell {
  buildInputs = [
    openssl_1_1
    (callPackage ./aptos.nix { })
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=${openssl_1_1.out}/lib:$LD_LIBRARY_PATH
  '';
}
