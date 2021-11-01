{ pkgs ? import<nixpkgs> {} }:

with pkgs;
let pythpkgs = with python38Packages; [
	pandas gensim scikitlearn pytorchWithoutCuda pycparser glob2
];
in
mkShell {
	buildInputs = [python38
	] ++ pythpkgs;
	SHELL_NAME = "ASTNN";
}
