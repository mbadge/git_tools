#!/usr/bin/env bash
# Test runner script for git_tools repository
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo -e "${YELLOW}Git Tools Test Runner${NC}"
echo "======================================"

# Check if BATS is installed
if [ ! -d "${SCRIPT_DIR}/lib/bats-core" ]; then
    echo -e "${YELLOW}BATS is not installed. Running setup...${NC}"
    bash "${SCRIPT_DIR}/setup_bats.sh"
    echo ""
fi

# Set up BATS executable
BATS="${SCRIPT_DIR}/lib/bats-core/bin/bats"

if [ ! -x "${BATS}" ]; then
    echo -e "${RED}Error: BATS executable not found at ${BATS}${NC}"
    echo "Please run: ./test/setup_bats.sh"
    exit 1
fi

# Parse command line arguments
VERBOSE=""
FILTER=""
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE="--verbose-run"
            shift
            ;;
        -f|--filter)
            FILTER="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -v, --verbose     Show verbose output"
            echo "  -f, --filter FILE Run only tests matching FILE pattern"
            echo "  -h, --help        Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Find test files
if [ -n "${FILTER}" ]; then
    TEST_FILES=$(find "${SCRIPT_DIR}" -name "${FILTER}*.bats" -type f)
else
    TEST_FILES=$(find "${SCRIPT_DIR}" -name "*.bats" -type f)
fi

if [ -z "${TEST_FILES}" ]; then
    echo -e "${RED}No test files found${NC}"
    exit 1
fi

echo "Running tests..."
echo ""

# Run tests
if ${BATS} ${VERBOSE} ${TEST_FILES}; then
    echo ""
    echo -e "${GREEN}✓ All tests passed!${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}✗ Some tests failed${NC}"
    exit 1
fi
