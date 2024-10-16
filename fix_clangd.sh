#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

if [ ! -f "$1/CMakeLists.txt" ]; then
    echo "Error: $1 does not contain a CMakeLists.txt file."
    read -r -p "Do you want to create a template CMakeLists.txt file? (y/n) " create_template
    if [ "$create_template" == "y" ]; then
        cp ./cmake-template "$1/CMakeLists.txt"
        echo "int main(int argc, char **argv) { return 0; }" > "$1/template.cpp"
        echo "Template CMakeLists.txt file created in $1."
    else
        exit 1
    fi
fi

# We use _build so this doesn't effect the usual build process
mkdir -p "$1/_build"
cd "$1/_build" || exit 1

# Run CMake and generate the compile_commands.json file
CLANGD_FIX=1 cmake ..

# Patch compile_commands.json
sed 's/\\\"//g' < compile_commands.json > ../compile_commands.json
