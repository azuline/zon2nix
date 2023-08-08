{
  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # https://github.com/NixOS/nixpkgs/pull/247437 is not in nixos-unstable yet
    nixpkgs.url = "github:nixos/nixpkgs/6bf8b8b600d24779d283e3ec526e317a82910a7e";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem = { pkgs, ... }:
        let
          inherit (pkgs)
            stdenv
            zigHook
            zig_0_11
            ;
        in
        {
          packages.default = stdenv.mkDerivation {
            pname = "zon2nix";
            version = "0.1.0";
            src = ./.;
            nativeBuildInputs = [
              (zigHook.override {
                zig = zig_0_11;
              })
            ];
          };
        };
    };
}