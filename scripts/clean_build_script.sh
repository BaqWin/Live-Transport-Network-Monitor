#!/bin/bash

set -e  # Exit immediately if a command fails
set -o pipefail  # Ensure pipeline commands fail properly
set -x  # Print executed commands

# Get the absolute path of the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."
BUILD_DIR="$PROJECT_ROOT/build"

# Remove all contents of the build directory except .gitignore
if [ -d "$BUILD_DIR" ]; then
    find "$BUILD_DIR" -mindepth 1 ! -name ".gitignore" -exec rm -rf {} +
else
    mkdir -p "$BUILD_DIR"
fi

# Navigate to the build directory
cd "$BUILD_DIR"

# Run Conan install with the correct profile
conan install "$PROJECT_ROOT" --build=missing --profile="$PROJECT_ROOT/conanprofile.toml" --output-folder=.

# Configure CMake with Ninja and Conan toolchain
cmake "$PROJECT_ROOT" -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake

# Build the project with Ninja
ninja

# Run the compiled binary if the build succeeds
./network-monitor
