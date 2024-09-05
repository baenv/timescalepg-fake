{
  description = "A flake that adds the timescaledb extension to Postgresql";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        psqlExtensions = [
          "timescaledb"
        ];
      in {
        packages = {
          postgresql = pkgs.postgresql_15.withPackages (ps:
              (map (ext: ps."${ext}") psqlExtensions));
        };

        defaultPackage = self.packages.${system}.postgresql;
      });
}
