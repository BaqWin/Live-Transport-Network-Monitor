#!/bin/bash

set -e  # Exit immediately if a command fails
set -o pipefail  # Ensure pipeline commands fail properly
set -x  # Print executed commands

# Get the absolute path of the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."
BUILD_DIR="$PROJECT_ROOT/build"

# Navigate to the build directory
cd "$BUILD_DIR"

# Configure CMake with Ninja and Conan toolchain
cmake "$PROJECT_ROOT" -GNinja -DCMAKE_BUILD_TYPE=Release

# Build the project with Ninja
ninja

# Run the compiled binary if the build succeeds
./network-monitor
