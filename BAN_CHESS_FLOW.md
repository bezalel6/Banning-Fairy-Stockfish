# Ban Chess Game Flow

## The Core Concept
In Ban Chess, before each move, the opponent selects one legal move to ban. The player must then make a different move.

## Ply-Based Implementation

Ban Chess uses a ply-doubling system where each traditional "turn" becomes two plies:

### Starting Position
- White to move
- Ban Chess Ply = 1 (ban phase)
- Black will ban one of White's legal moves

### Game Flow

| Ply | Phase | Active Player | Action | Next |
|-----|-------|---------------|--------|------|
| 1 | Ban | Black | Bans one of White's moves | White moves |
| 2 | Move | White | Makes a legal move (avoiding ban) | Black's turn |
| 3 | Ban | White | Bans one of Black's moves | Black moves |
| 4 | Move | Black | Makes a legal move (avoiding ban) | White's turn |
| 5 | Ban | Black | Bans one of White's moves | White moves |
| ... | ... | ... | ... | ... |

## Key Points

1. **Who Bans**: The player who is NOT to move selects the ban
   - When it's White's turn to move, Black bans
   - When it's Black's turn to move, White bans

2. **Ply Counting**:
   - Odd plies (1, 3, 5...): Ban phase
   - Even plies (2, 4, 6...): Move phase

3. **Side to Move**:
   - Does NOT change after a ban
   - Changes after a move (as in regular chess)

4. **UCI Protocol**:
   - Each action (ban or move) is communicated as a move in UCI
   - The position tracks internally whether it's a ban or move
   - Example: "position startpos moves e2e4 d2d4"
     - e2e4 = Black bans White's e2e4 (ply 1)
     - d2d4 = White plays d2d4 (ply 2)

## Checkmate by Ban

If a player is in check with only one legal move, the opponent can ban that move to achieve checkmate.

## Implementation Details

The Position class tracks:
- `banChessPly`: Current ply in the Ban Chess game
- `currentBan`: The currently active ban (MOVE_NONE during ban phase)
- Side to move follows standard chess rules but with ban phases inserted