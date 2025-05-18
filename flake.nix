{
    description = "CrumblyLiquid's personal website";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = {self, nixpkgs, flake-utils }: 
        flake-utils.lib.eachDefaultSystem (system:
            let
                pkgs = nixpkgs.legacyPackages.${system};
            in {

                packages.website = pkgs.stdenv.mkDerivation rec {
                    name = "crumblyweb";
                    src = self;
                    nativeBuildInputs = with pkgs; [ sass ];
                    buildPhase = "sass liquid.scss > liquid.css";
                    installPhase = "cp -r . $out";
                };

                defaultPackage = self.packages.${system}.website;

                devShell = pkgs.mkShell {
                    packages = with pkgs; [
                        sass
                    ];
                };
            }
        );
}
