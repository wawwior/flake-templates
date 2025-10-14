{
  description = "";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    neat-flakes.url = "github:wawwior/neat-flakes";
  };

  outputs =
    inputs@{ self, ... }:
    inputs.neat-flakes.lib.eachSystem
      [
        "x86_64-linux"
        "aarch64-linux"
      ]
      (
        system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
          };
        in
        {
          devShells.${system} = {
            default = {
              packages = [
                pkgs.tinymist
              ];
            };
          };
        }
      );
}
