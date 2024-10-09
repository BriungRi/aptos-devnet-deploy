with import <nixpkgs> { };

pkgs.mkShell {
  buildInputs = [
    (callPackage ./aptos.nix { })
  ];
}
