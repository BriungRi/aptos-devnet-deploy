with import <nixpkgs> { };

pkgs.mkShell {
  buildInputs = [
    jq
    (callPackage ./aptos.nix { })
  ];
}
