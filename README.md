# Nix flake for c++23 + clang

Unfortunately, the clang 18 wrapper still uses gcc13Stdenv, including the old standard library. This flake provides an override for the clang wrapper and attempts to fix the issue for clangd as well.

## Usage
* The `clang` and `clang++` provided in the devShell can be used as-is
* For clangd to work, add the following to your CMakeLists.txt
```cmake
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
if(CMAKE_EXPORT_COMPILE_COMMANDS)
  set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})
endif()
```
