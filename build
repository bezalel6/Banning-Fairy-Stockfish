#!/bin/bash
# Build script for Fairy-Stockfish - works in Git Bash, WSL, or MSYS2

echo "========================================"
echo "Fairy-Stockfish Unix/Git Bash Build"
echo "========================================"
echo ""

# Detect environment and set up paths accordingly
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ -n "$MSYSTEM" ]]; then
    # Git Bash or MSYS2 on Windows
    echo "Detected Windows environment (Git Bash/MSYS2)"
    
    # Check for MSYS2 installation
    if [ -f "/c/msys64/mingw64/bin/g++.exe" ]; then
        export PATH="/c/msys64/mingw64/bin:/c/msys64/usr/bin:$PATH"
        MAKE_CMD="/c/msys64/mingw64/bin/mingw32-make.exe"
        COMPILER="mingw"
    elif [ -f "/mingw64/bin/g++.exe" ]; then
        export PATH="/mingw64/bin:/usr/bin:$PATH"
        MAKE_CMD="mingw32-make"
        COMPILER="mingw"
    else
        echo "ERROR: MSYS2 MinGW64 not found!"
        echo "Please install MSYS2 from https://www.msys2.org/"
        exit 1
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux or WSL
    echo "Detected Linux/WSL environment"
    MAKE_CMD="make"
    COMPILER="gcc"
else
    echo "Detected Unix-like environment"
    MAKE_CMD="make"
    COMPILER="gcc"
fi

# Parse arguments
BUILD_TYPE="${1:-build}"
ARCH="${2:-x86-64-modern}"

# Navigate to src directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/src" || exit 1

# Handle different build commands
case "$BUILD_TYPE" in
    clean)
        echo "Cleaning build files..."
        rm -f *.o *.exe
        echo "Clean complete!"
        exit 0
        ;;
    quick)
        echo "Quick build (no optimization)..."
        g++ -o stockfish.exe -O2 -std=c++17 -static \
            benchmark.cpp bitboard.cpp endgame.cpp evaluate.cpp main.cpp \
            material.cpp misc.cpp movegen.cpp movepick.cpp partner.cpp \
            pawns.cpp piece.cpp position.cpp psqt.cpp search.cpp \
            thread.cpp timeman.cpp tt.cpp uci.cpp ucioption.cpp \
            parser.cpp variant.cpp xboard.cpp zobrist.cpp \
            syzygy/tbprobe.cpp nnue/evaluate_nnue.cpp \
            nnue/features/half_ka_v2_hm.cpp -lpthread
        ;;
    test)
        echo "Building and testing..."
        $MAKE_CMD -j build ARCH=$ARCH COMP=$COMPILER LDFLAGS="-static"
        if [ -f "stockfish.exe" ] || [ -f "stockfish" ]; then
            echo ""
            echo "Running bench test..."
            ./stockfish* bench
        fi
        ;;
    *)
        echo "Build type: $BUILD_TYPE"
        echo "Architecture: $ARCH"
        echo "Compiler: $COMPILER"
        echo ""
        echo "Building Fairy-Stockfish..."
        $MAKE_CMD -j $BUILD_TYPE ARCH=$ARCH COMP=$COMPILER LDFLAGS="-static"
        ;;
esac

# Check if build succeeded
if [ -f "stockfish.exe" ] || [ -f "stockfish" ]; then
    echo ""
    echo "========================================"
    echo "Build successful!"
    echo "Output: src/stockfish*"
    ls -lh stockfish* | head -1
    echo ""
    echo "Test with: ./stockfish* bench"
    echo "========================================"
else
    echo ""
    echo "========================================"
    echo "Build failed! No executable created."
    echo "Try running: ./build.sh clean"
    echo "========================================"
    exit 1
fi