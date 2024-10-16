# Nix flake for c++23 + clang

Unfortunately, the clang 18 wrapper still uses gcc13Stdenv, including the old standard library. This flake provides an override for the clang wrapper and attempts to fix the issue for clangd as well.

> [!NOTE]  
> The clangd fix is a hacky solution and I am sure there is a way to do this in nix directly. Feel free to improve my work!

## Usage
* The `clang` and `clang++` provided in the devShell can be used as-is
* For clangd to work, 2 extra steps are necessary:
  * Add the following to your CMakeLists.txt
```cmake
if(DEFINED ENV{CLANGD_PARAMS})
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
  string(REPLACE "\n" " " EXTRA_ARGS $ENV{CLANGD_PARAMS})
  add_compile_options(${EXTRA_ARGS})
endif()
```
  * Run this command to generate `compile_commands.json`
```bash
./fix_clangd.sh <source directory>
```
> [!WARNING]  
> Generating `compile_commands.json` any other way will break clangd
