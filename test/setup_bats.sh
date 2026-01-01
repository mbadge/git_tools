#!/usr/bin/env bash
# Setup script to install BATS testing framework
set -euo pipefail

echo "Setting up BATS (Bash Automated Testing System)..."

# Create test lib directory
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${TEST_DIR}/lib"
mkdir -p "${LIB_DIR}"

# Clone BATS and helper libraries if not already present
if [ ! -d "${LIB_DIR}/bats-core" ]; then
    echo "Installing bats-core..."
    git clone --depth 1 https://github.com/bats-core/bats-core.git "${LIB_DIR}/bats-core"
fi

if [ ! -d "${LIB_DIR}/bats-support" ]; then
    echo "Installing bats-support..."
    git clone --depth 1 https://github.com/bats-core/bats-support.git "${LIB_DIR}/bats-support"
fi

if [ ! -d "${LIB_DIR}/bats-assert" ]; then
    echo "Installing bats-assert..."
    git clone --depth 1 https://github.com/bats-core/bats-assert.git "${LIB_DIR}/bats-assert"
fi

if [ ! -d "${LIB_DIR}/bats-file" ]; then
    echo "Installing bats-file..."
    git clone --depth 1 https://github.com/bats-core/bats-file.git "${LIB_DIR}/bats-file"
fi

echo "BATS setup complete!"
echo "Run tests with: ./test/run_tests.sh"
