#!/bin/bash
# Build Sphinx documentation with optional flags

set -e

DOCS_DIR="${1:-.}"
BUILD_TYPE="${2:-html}"
CLEAN="${3:-true}"

if [ "$CLEAN" = "true" ]; then
    echo "Cleaning previous build..."
    rm -rf "$DOCS_DIR/build"
fi

cd "$DOCS_DIR"

echo "Building $BUILD_TYPE documentation..."
make "$BUILD_TYPE"

if [ "$BUILD_TYPE" = "html" ]; then
    BUILD_PATH="$(pwd)/build/html/index.html"
    echo "✅ Build complete!"
    echo "📖 View at: $BUILD_PATH"

    # Try to open in browser (if available)
    if command -v open &> /dev/null; then
        open "$BUILD_PATH"
    elif command -v xdg-open &> /dev/null; then
        xdg-open "$BUILD_PATH"
    elif command -v start &> /dev/null; then
        start "$BUILD_PATH"
    fi
else
    echo "✅ Build complete in build/$BUILD_TYPE/"
fi
