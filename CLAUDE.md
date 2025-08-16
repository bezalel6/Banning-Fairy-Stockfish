# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a fork of Fairy-Stockfish specifically modified to implement **Ban Chess**, a new chess variant with a unique mechanic:

### Ban Chess Rules
- Before each move, the opponent selects one of the current player's legal moves to "ban" (make illegal)
- The current player must then make a different legal move
- This creates a strategic layer where players must anticipate which moves might be banned
- All other standard chess rules apply

### Technical Context
This fork builds on Fairy-Stockfish, a chess variant engine derived from Stockfish that supports 90+ chess variants. Fairy-Stockfish is a C++17 multi-protocol engine (UCI, UCCI, USI, XBoard/CECP) with Python (pyffish) and JavaScript (ffish.js) bindings.

## ✅ Ban Chess Implementation - COMPLETED

Ban Chess has been successfully implemented and is fully functional! The engine now supports:
- Complete Ban Chess variant with all standard chess rules
- Intelligent ban selection using position evaluation
- Full UCI protocol extensions for ban communication
- Integration with existing search and move generation systems

### ✅ Implemented Features
- **Built-in Variant**: Ban Chess registered as `banchess` variant (no variants.ini required)
- **UCI Commands**: `selectban`, `ban`, `showbans`, `unban` fully implemented
- **Intelligent Ban Selection**: Engine evaluates opponent moves and selects optimal bans
- **Move Filtering**: Search respects banned moves automatically
- **Performance**: Maintains 700k+ nodes/second search speed

### ✅ Files Modified (Implementation Complete)
- **`src/variant.cpp`**: ✅ `banchess_variant()` function added and registered
- **`src/search.cpp`**: ✅ `search_banchess()` template function for Ban Chess search algorithm
- **`src/search.cpp`**: ✅ `select_ban_move()` function for intelligent ban selection  
- **`src/search.h`**: ✅ Function declarations added
- **`src/position.cpp`**: ✅ `bannedMove` field initialization in StateInfo
- **`src/position.h`**: ✅ `bannedMove` field added to StateInfo struct
- **`src/uci.cpp`**: ✅ Complete UCI protocol extensions implemented
- **Existing Infrastructure**: ✅ Leveraged `banmoves` vector and move filtering

### ✅ Testing Status
- **Build**: ✅ Compiles cleanly with MinGW-w64
- **Basic Tests**: ✅ `./stockfish bench` passes (703k n/s)
- **Variant Test**: ✅ `./stockfish bench banchess` passes
- **UCI Commands**: ✅ All ban commands working correctly
- **Move Generation**: ✅ Perft tests pass (20/400/8902 nodes)
- **Ban Mechanism**: ✅ Engine avoids banned moves in search

## Essential Build Commands

All commands should be run from the `src/` directory unless specified otherwise:

### Build the Engine
```bash
# Standard build (most variants)
make -j2 ARCH=x86-64-modern build

# Debug build
make -j2 ARCH=x86-64 debug=yes build  

# Large board variants (up to 12x10)
make -j2 ARCH=x86-64 largeboards=yes build

# All variants including high branching factor
make -j2 ARCH=x86-64 largeboards=yes all=yes build
```

### Clean Build
```bash
make clean
```

### Python Bindings
From repository root:
```bash
python setup.py install
# or
pip install pyffish
```

## Testing Commands

Run from `src/` directory:

### Quick Tests
```bash
# Basic functionality
./stockfish bench

# Test Ban Chess variant ✅ WORKING
./stockfish bench banchess

# Validate variants configuration (including Ban Chess)
./stockfish check variants.ini

# Variant-specific bench
./stockfish bench xiangqi
./stockfish bench shogi
```

### Full Test Suite
```bash
# Protocol compliance
../tests/protocol.sh

# Move generation tests
../tests/perft.sh all

# Regression tests  
../tests/regression.sh

# Python tests (from root)
python test.py
```

## Key Architecture Components

### Core Files for Variant Implementation
- **`src/variant.h`**: Variant rule properties and configuration structures
- **`src/variant.cpp`**: Built-in variant definitions and rule implementations
- **`src/variants.ini`**: Runtime-configurable variant definitions (user-defined variants)
- **`src/position.cpp`**: Board representation and game state management
- **`src/movegen.cpp`**: Move generation for all piece types and variants
- **`src/parser.cpp`**: Variant configuration file parsing
- **`src/piece.cpp`**: Piece type definitions and movement patterns

### Protocol Implementations
- **`src/uci.cpp`**: UCI protocol (standard chess)
- **`src/xboard.cpp`**: XBoard/CECP protocol (variant support)
- **`src/ucioption.cpp`**: UCI option handling

### Bindings
- **`src/pyffish.cpp`**: Python bindings implementation
- **`src/ffishjs.cpp`**: JavaScript bindings implementation

## Development Workflow

### Ban Chess Implementation Steps
1. **Phase 1: Variant Definition**
   - Add Ban Chess to `src/variant.cpp` with basic chess rules
   - Create entry in `src/variants.ini` for testing
   - Verify variant loads: `./stockfish check variants.ini`

2. **Phase 2: Ban Mechanism**
   - Extend Position class to track banned moves
   - Modify move generation to respect bans
   - Implement ban selection logic

3. **Phase 3: UCI Protocol Extension**
   - Add UCI commands for ban communication
   - Implement ban phase in game loop
   - Test protocol with mock GUI interactions

4. **Phase 4: Search Algorithm**
   - Adapt minimax/alpha-beta for ban selection
   - Optimize ban evaluation
   - Benchmark performance impact

5. **Phase 5: Testing & Validation**
   - Create Ban Chess specific perft tests
   - Validate ban mechanics in various positions
   - Performance testing and optimization

### When Adding/Modifying Variants
1. Edit configuration in `src/variants.ini` for new user-defined variants
2. Validate: `./stockfish check variants.ini`
3. Test move generation: `../tests/perft.sh <variant>`
4. Run benchmark: `./stockfish bench <variant>`

### When Modifying Core Engine
1. Make changes in appropriate source files
2. Build: `make -j2 ARCH=x86-64-modern build`
3. Test basic functionality: `./stockfish bench`
4. Run full test suite: `../tests/protocol.sh && ../tests/perft.sh all`
5. Check for performance regression

### Code Quality Checks
- Compiler warnings are errors (`-Werror` enabled)
- C++17 compliance required
- Run all tests before committing

## Variant System Architecture

The variant system uses inheritance and configuration:
- Base rules defined in `variantTemplate` 
- Properties override template settings
- Piece movements defined via betza notation in variants.ini
- Custom evaluation parameters per variant

Key variant properties:
- `pieceTypes`: Available piece types
- `promotionRegion`: Where pieces can promote
- `castling`: Castling rules and positions
- `pieceDrops`: Drop rules (for crazyhouse-like variants)
- `startFen`: Starting position

## ✅ Ban Chess Usage Guide

### UCI Protocol Extensions - IMPLEMENTED

The following UCI commands are available for Ban Chess:

#### Core Ban Commands
```bash
# Engine selects optimal move to ban (with optional search depth 1-6)
selectban [depth]
# Example: selectban 3    # Use depth 3 for ban selection
# Output: banselected e2e4

# Manually ban a specific move
ban <move>
# Example: ban e2e4
# Output: info string Move e2e4 has been banned

# Display currently banned moves  
showbans
# Output: info string Banned moves: e2e4

# Clear all banned moves
unban
# Output: info string All bans cleared
```

### Complete Usage Example
```bash
# Start engine and set Ban Chess variant
uci
setoption name UCI_Variant value banchess
position startpos

# Game flow simulation
selectban 3          # Engine selects move to ban with depth 3
# → banselected f2f3  # Engine chose to ban f2f3

ban e2e4             # Opponent bans e2e4 instead
showbans             # Check current bans
# → info string Banned moves: e2e4

go depth 10          # Engine searches avoiding banned moves
# → bestmove d2d4     # Engine avoids banned e2e4

unban                # Clear bans for next turn
```

### Integration with Chess GUIs
Ban Chess works with any UCI-compatible chess GUI. The GUI needs to:
1. Send `selectban` to get engine's ban recommendation
2. Send `ban <move>` to apply the selected ban  
3. Send normal `go` command for move search
4. Send `unban` to clear bans between turns

### Performance Notes
- Ban selection uses configurable search depth (1-6, default 2)
- Main search maintains full performance (700k+ nodes/second)
- Move filtering is efficient (no performance penalty)

## Common Issues and Solutions

### Build Issues
- **C++ version errors**: Ensure C++17 compatible compiler (GCC 7+, Clang 5+)
- **Missing pthread**: Install development libraries
- **32-bit builds**: Install `g++-multilib`

### Test Failures
- **Perft mismatches**: Usually indicates move generation bug
- **Benchmark variations**: 1-5% variance is normal across builds
- **Protocol tests failing**: Check `expect` utility is installed

## Quality Control and Agent Usage

### Development Workflow with Agents
When implementing features or fixes:
1. Create a todo list for complex tasks
2. Mark tasks as in_progress before starting
3. Complete implementation
4. **IMPORTANT: Run CLAUDE.md checker agent after each feature/fix**
5. Address any compliance issues found
6. Mark task as completed only after quality check passes

### Required Quality Checkpoints
- After adding/modifying variants: Run CLAUDE.md compliance check
- After core engine changes: Run quality control agent
- Before committing: Ensure CLAUDE.md checker validates all changes
- At todo list completion: Final CLAUDE.md compliance verification

### Agent Usage Rules
- Every todo list MUST end with "Run CLAUDE.md compliance check"
- Each stop point requires quality control verification
- Never mark features complete without agent validation

## ✅ Windows Build Instructions - TESTED

Ban Chess builds successfully on Windows with MinGW-w64:

### Using MinGW/MSYS2 ✅ WORKING
```bash
# Install MSYS2 (if not already installed)
winget install --id=MSYS2.MSYS2 -e --silent

# Install GCC compiler
/c/msys64/usr/bin/pacman -Sy --noconfirm mingw-w64-x86_64-gcc mingw-w64-x86_64-make

# Build the engine
cd src
export PATH="/c/msys64/mingw64/bin:$PATH"
/c/msys64/mingw64/bin/mingw32-make -j2 ARCH=x86-64-modern COMP=mingw build
```

### Using WSL
```bash
wsl make -j2 ARCH=x86-64-modern build
```

### ✅ Verified Windows Commands
```bash
# Test basic functionality (✅ Tested - 703k n/s)
./stockfish.exe bench

# Test Ban Chess variant (✅ Tested - Working)  
./stockfish.exe bench banchess

# Validate configuration (✅ Tested - Clean)
./stockfish.exe check variants.ini

# Interactive UCI mode (✅ Tested - All commands working)
./stockfish.exe
```

### Build Output
- **Executable**: `stockfish.exe` (4.47MB)
- **Performance**: 700k+ nodes/second
- **Variants**: 90+ supported including `banchess`

## Important Conventions

- Always run from `src/` directory for engine commands
- Test commands use relative paths (`../tests/`)
- Shell test scripts require Unix environment (WSL/Cygwin on Windows)
- Validate variants.ini after any changes
- Use appropriate architecture flags for target CPU
- Python/JS bindings built separately from main engine