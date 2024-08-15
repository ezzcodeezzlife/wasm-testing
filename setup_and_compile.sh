#!/bin/bash

# Exit script on any error
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if git is installed
if ! command_exists git; then
    echo "git is not installed. Please install git and try again."
    exit 1
fi

# Check if Python is installed
if ! command_exists python; then
    echo "Python is not installed. Please install Python and try again."
    exit 1
fi

# Clone the Emscripten SDK repository
echo "Cloning Emscripten SDK repository..."
git clone https://github.com/emscripten-core/emsdk.git

# Navigate into the emsdk directory
cd emsdk

# Install the latest Emscripten SDK
echo "Installing Emscripten SDK..."
./emsdk install latest

# Activate the latest Emscripten SDK
echo "Activating Emscripten SDK..."
./emsdk activate latest

# Set up environment variables
echo "Setting up environment variables..."
source ./emsdk_env.sh

# Check if the emcc command is available
if ! command_exists emcc; then
    echo "emcc command not found. Please ensure Emscripten was installed correctly."
    exit 1
fi

# Path to the C++ source file (update this path if necessary)
CPP_FILE_PATH="../mandelbrot.cpp"

# Determine the absolute path to the C++ file
ABS_CPP_FILE_PATH=$(realpath "$CPP_FILE_PATH")

# Check if the C++ source file exists
if [ -f "$ABS_CPP_FILE_PATH" ]; then
    echo "Compiling $ABS_CPP_FILE_PATH to WebAssembly..."
    # Navigate back to the original directory to ensure the output files are placed correctly
    cd ..
    emcc mandelbrot.cpp -o mandelbrot.js -s EXPORTED_FUNCTIONS='["_compute_mandelbrot", "_malloc", "_free"]' -s EXTRA_EXPORTED_RUNTIME_METHODS='["cwrap", "ccall", "HEAPU8"]'
    echo "Compilation complete. Files generated: mandelbrot.js and mandelbrot.wasm"
else
    echo "$ABS_CPP_FILE_PATH not found. Please make sure the file exists at the specified path."
    exit 1
fi
