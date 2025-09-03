/*
  Ban Chess Helper Functions
*/

#ifndef BANCHESS_HELPERS_H_INCLUDED
#define BANCHESS_HELPERS_H_INCLUDED

#include "types.h"
#include "position.h"
#include "movegen.h"

namespace Stockfish {

// Generate legal moves for Ban Chess
// In ban ply: generates opponent's moves (for ban selection)
// In move ply: generates current player's moves (excluding banned move)
template<typename T>
inline void generate_ban_chess_moves(const Position& pos, T& moveList) {
    if (pos.is_ban_ply()) {
        // Ban ply: We need opponent's moves
        // Create a temporary position with flipped side
        Position tempPos = pos;
        tempPos.flip_side_to_move_for_ban();
        
        // Generate opponent's legal moves
        MoveList<LEGAL> oppMoves(tempPos);
        for (const auto& m : oppMoves) {
            moveList.push_back(m);
        }
    } else {
        // Move ply: Generate our moves, excluding the banned move
        MoveList<LEGAL> moves(pos);
        Move banned = pos.banned_move();
        
        for (const auto& m : moves) {
            if (m != banned) {
                moveList.push_back(m);
            }
        }
    }
}

// Check if position is checkmate considering Ban Chess rules
inline bool is_ban_chess_checkmate(const Position& pos) {
    if (!pos.checkers()) return false;
    
    if (pos.is_ban_ply()) {
        // In ban phase: if opponent (who is in check) has only one legal move,
        // we can ban it for checkmate
        Position tempPos = pos;
        tempPos.flip_side_to_move_for_ban();
        MoveList<LEGAL> moves(tempPos);
        return moves.size() == 1;
    } else {
        // In move phase: standard checkmate check (no legal moves after ban)
        MoveList<LEGAL> moves(pos);
        Move banned = pos.banned_move();
        
        // Count moves excluding the banned one
        int legalMoves = 0;
        for (const auto& m : moves) {
            if (m != banned) legalMoves++;
        }
        return legalMoves == 0;
    }
}

} // namespace Stockfish

#endif // #ifndef BANCHESS_HELPERS_H_INCLUDED