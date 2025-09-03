# Ban Chess Clean Implementation Design

## Core Concept: Ply-Based Game Flow

Ban Chess doubles the ply count - each traditional "move" becomes two plies:
- **Odd plies**: Ban phase (opponent selects one move to ban)
- **Even plies**: Move phase (player makes a legal move, avoiding the ban)

## Game Flow
```
Ply 1: Black bans one of White's legal moves
Ply 2: White makes a move (avoiding the ban)
Ply 3: White bans one of Black's legal moves  
Ply 4: Black makes a move (avoiding the ban)
...and so on
```

## Key Design Principles

1. **Unified Action System**: Both bans and moves are "actions" in the game tree
2. **No Separate Ban State**: The ply number determines if we're in ban or move phase
3. **Clean Position Representation**: Position tracks current ban (if any) as part of state
4. **Natural Search Integration**: Search handles both ban selection and move selection

## Implementation Architecture

### 1. Position Class Changes
```cpp
class Position {
    // Add to StateInfo:
    Move currentBan;     // The currently active ban (MOVE_NONE if in ban phase)
    int gamePly;         // Track game ply for ban/move phase determination
    
    // New methods:
    bool is_ban_ply() const { return gamePly % 2 == 1; }
    bool is_move_ply() const { return gamePly % 2 == 0; }
    Move banned_move() const { return st->currentBan; }
    
    // Modified do_move:
    // - If ban ply: store the ban, increment ply, switch turn
    // - If move ply: execute move, clear ban, increment ply, switch turn
};
```

### 2. Move Generation
```cpp
// Generate legal moves based on current ply type
template<GenType Type>
ExtMove* generate(const Position& pos, ExtMove* moveList) {
    if (pos.is_ban_ply()) {
        // Generate opponent's legal moves (these are ban candidates)
        // Switch perspective temporarily to generate opponent moves
        return generate_ban_candidates(pos, moveList);
    } else {
        // Generate normal legal moves, excluding the banned move
        ExtMove* end = generate_normal<Type>(pos, moveList);
        // Filter out the banned move if any
        if (pos.banned_move() != MOVE_NONE) {
            remove_banned_move(moveList, end, pos.banned_move());
        }
        return end;
    }
}
```

### 3. Search Algorithm
```cpp
// Unified search handles both ban and move selection
Value search(Position& pos, Stack* ss, Value alpha, Value beta, Depth depth) {
    if (pos.is_ban_ply()) {
        // Ban selection: find the move that minimizes opponent's best response
        // Perspective: we want to hurt the opponent most
        Value bestBanValue = -VALUE_INFINITE;
        Move bestBan = MOVE_NONE;
        
        for (each legal opponent move) {
            pos.do_ban(move);  // Apply this ban
            Value v = -search(pos, ss+1, -beta, -alpha, depth-1);
            pos.undo_ban();
            
            if (v > bestBanValue) {
                bestBanValue = v;
                bestBan = move;
            }
        }
        return bestBanValue;
    } else {
        // Normal move selection (with banned move filtered out)
        // Standard alpha-beta search
        return normal_search(pos, ss, alpha, beta, depth);
    }
}
```

### 4. UCI Protocol
```cpp
// Clean UCI implementation
void uci_loop() {
    // Standard position command works naturally
    // "position startpos moves e2e4 e7e5 d2d4"
    // This represents: ban e2e4, move e7e5, ban d2d4, etc.
    
    // Each "move" in UCI is actually an action (ban or move)
    // The engine knows from ply count what type each is
    
    // go command returns the best action (ban or move)
    // "bestmove e2e4" could be either a ban or move depending on ply
}
```

### 5. Checkmate Detection
```cpp
bool Position::is_checkmate() const {
    if (!checkers()) return false;
    
    if (is_ban_ply()) {
        // In ban phase: if king is in check and has only one escape,
        // the opponent can ban it for checkmate
        MoveList<LEGAL> moves(*this);
        return moves.size() == 1;
    } else {
        // In move phase: standard checkmate (no legal moves)
        MoveList<LEGAL> moves(*this);
        // Filter out banned move
        if (banned_move() != MOVE_NONE) {
            moves.remove(banned_move());
        }
        return moves.empty();
    }
}
```

## Benefits of This Design

1. **Simplicity**: No separate ban tracking system
2. **Elegance**: Bans and moves are unified as "actions"
3. **Performance**: Natural integration with existing search
4. **Compatibility**: Works with standard UCI protocol
5. **Clarity**: Game state is always clear from ply number

## Migration Plan

1. Remove all old Ban Chess code
2. Modify Position class for ply-based system
3. Update move generation
4. Implement unified search
5. Simplify UCI protocol handling
6. Add comprehensive tests