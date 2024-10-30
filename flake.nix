{
  description = "Concepts of C++ flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (self: super: rec {
              clang_18 = super.clang_18.override {
                gccForLibs = pkgs.gcc14Stdenv.cc.cc;
              };
            })
          ];
        };
      in
      {
        packages.default = pkgs.clang_18;

        devShell =
          pkgs.mkShell.override
            {
              stdenv = pkgs.stdenvNoCC;
            }
            {
              buildInputs = with pkgs; [
                cmake
                gtest
                clang-manpages
                clang_18
                clang-tools_18
              ];
              CC = "${pkgs.clang_18}/bin/clang";
              CXX = "${pkgs.clang_18}/bin/clang++";
            };
      }
    );
}
