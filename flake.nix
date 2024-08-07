{
  description = "tEsc template";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    tex2nix.url = "github:rgri/tex2nix";
    tex2nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, tex2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        texPkgs = (pkgs.callPackage ./tex-env.nix {
          extraTexPackages = {
            inherit (pkgs.texlive) latexmk
            collection-langcyrillic bbm-macros rsfs;
          };
        });

        devTools = with pkgs; [
          bashInteractive
          
          tex2nix.packages.${system}.tex2nix
        ];
      in {
        devShell = pkgs.mkShell ({
          buildInputs = devTools ++ [texPkgs];
        });
      }
    );
}
