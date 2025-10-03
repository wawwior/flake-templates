{
  description = "";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    crane.url = "github:ipetkov/crane";
  };

  outputs =
    inputs@{ self, ... }:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};

        craneLib = inputs.crane.mkLib pkgs;

        src = craneLib.cleanCargoSource ./.;

        commonArgs = {
          inherit src;
          strictDeps = true;

          buildInputs = [ ];
        };

        cargoArtifacts = craneLib.buildDepsOnly commonArgs;

        package = craneLib.buildPackage (
          commonArgs
          // {
            inherit cargoArtifacts;
          }
        );
      in
      {
        checks = {
          inherit package;

          package-clippy = craneLib.cargoClippy (
            commonArgs
            // {
              inherit cargoArtifacts;
            }
          );

          package-doc = craneLib.cargoDoc (
            commonArgs
            // {
              inherit cargoArtifacts;
            }
          );

          package-fmt = craneLib.cargoFmt {
            inherit src;
          };

          package-deny = craneLib.cargoDeny {
            inherit src;
          };
        };

        packages = {
          default = package;
        };

        devShells = {
          default = craneLib.devShell {
            checks = self.checks.${system};

            packages = [
              pkgs.rust-analyzer
            ];
          };
        };
      }
    );
}
