{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      ...
    }:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ inputs.rust-overlay.overlays.default ];
        };
        lib = pkgs.lib;

        toolchain = pkgs.rust-bin.selectLatestNightlyWith (
          toolchain:
          toolchain.default.override {
            extensions = [
              "rust-analyzer"
            ];
          }
        );

        naersk' = pkgs.callPackage inputs.naersk {
          cargo = toolchain;
          rustc = toolchain;
        };
      in
      {
        defaultPackage = naersk'.buildPackage {
          src = ./.;
        };

        devShell = pkgs.mkShell rec {
          nativeBuildInputs = [
            toolchain
          ];

          LD_LIBRARY_PATH = "${lib.makeLibraryPath nativeBuildInputs}";
        };
      }
    );
}
