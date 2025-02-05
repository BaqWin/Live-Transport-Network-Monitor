#!/bin/bash

set -e  # Exit immediately if a command fails
set -o pipefail  # Ensure pipeline commands fail properly
set -x  # Print executed commands

# Remove all contents of the build directory except .gitignore
if [ -d "build" ]; then
    find build -mindepth 1 ! -name ".gitignore" -delete
else
    mkdir build
fi

# Navigate to the build directory
cd build

# Run Conan install with the correct profile
conan install .. --build=missing --profile=../conanprofile.toml --output-folder=.

# Configure CMake with Ninja and Conan toolchain
cmake .. -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake

# Build the project with Ninja
ninja

# Run the compiled binary if the build succeeds
./network-monitor
