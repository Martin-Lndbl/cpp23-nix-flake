{
  description = "Concepts of C++ flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils, }:
    flake-utils.lib.eachDefaultSystem
      (system:
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
          devShell = pkgs.mkShell.override
            {
              stdenv = pkgs.stdenvNoCC;
            }
            {
              buildInputs = with pkgs; [
                cmake
                clang_18
                clang-tools_18
              ];

              CC = "${pkgs.clang_18}/bin/clang";
              CXX = "${pkgs.clang_18}/bin/clang++";

              CLANGD_PARAMS = ''
                -idirafter ${pkgs.glibc.dev}/include
                -resource-dir=${pkgs.clang_18}/resource-root
                -isystem ${pkgs.llvmPackages_18.compiler-rt.dev}/include
                -isystem ${pkgs.gcc14Stdenv.cc.cc}/include/c++/14.2.0
                -isystem ${pkgs.gcc14Stdenv.cc.cc}/include/c++/14.2.0/x86_64-unknown-linux-gnu
              '';
            };
        }
      );
}
