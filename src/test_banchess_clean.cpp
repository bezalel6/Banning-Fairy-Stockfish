/*
  Test program for clean Ban Chess implementation
*/

#include <iostream>
#include <string>
#include "position.h"
#include "movegen.h"
#include "uci.h"

using namespace Stockfish;

int main() {
    std::cout << "Ban Chess Clean Implementation Test\n";
    std::cout << "====================================\n\n";
    
    // Initialize tables
    Position::init();
    
    // Create a Ban Chess position
    StateInfo st;
    Position pos;
    
    // Set Ban Chess variant
    Options["UCI_Variant"] = std::string("banchess");
    pos.set("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", false, nullptr, &st);
    
    std::cout << "Initial position:\n" << pos << "\n";
    std::cout << "Is Ban Chess: " << (pos.is_ban_chess() ? "Yes" : "No") << "\n";
    std::cout << "Ban Chess ply: " << pos.ban_chess_ply() << "\n";
    std::cout << "Is ban ply: " << (pos.is_ban_ply() ? "Yes" : "No") << "\n";
    std::cout << "Is move ply: " << (pos.is_move_ply() ? "Yes" : "No") << "\n";
    std::cout << "Banned move: " << (pos.banned_move() == MOVE_NONE ? "None" : UCI::move(pos, pos.banned_move())) << "\n";
    
    // Test ban phase (ply 1 - Black bans White's move)
    std::cout << "\nPly 1: Black should ban one of White's moves\n";
    std::cout << "Generating White's legal moves for ban selection:\n";
    
    // Flip to generate White's moves
    pos.flip_side_to_move_for_ban();
    MoveList<LEGAL> whiteMoves(pos);
    pos.flip_side_to_move_for_ban();  // Flip back
    
    int count = 0;
    for (const auto& m : whiteMoves) {
        std::cout << "  " << UCI::move(pos, m) << " ";
        if (++count % 10 == 0) std::cout << "\n";
    }
    std::cout << "\nTotal moves: " << whiteMoves.size() << "\n";
    
    // Simulate banning e2e4
    Move banMove = UCI::to_move(pos, "e2e4");
    if (banMove != MOVE_NONE) {
        StateInfo newSt;
        std::cout << "\nBanning move: e2e4\n";
        pos.do_ban(banMove, newSt);
        
        std::cout << "After ban:\n";
        std::cout << "Ban Chess ply: " << pos.ban_chess_ply() << "\n";
        std::cout << "Is ban ply: " << (pos.is_ban_ply() ? "Yes" : "No") << "\n";
        std::cout << "Is move ply: " << (pos.is_move_ply() ? "Yes" : "No") << "\n";
        std::cout << "Banned move: " << UCI::move(pos, pos.banned_move()) << "\n";
        std::cout << "Side to move: " << (pos.side_to_move() == WHITE ? "White" : "Black") << "\n";
        
        // Test move phase (ply 2 - White moves, avoiding the ban)
        std::cout << "\nPly 2: White moves (cannot play e2e4)\n";
        std::cout << "Legal moves:\n";
        
        MoveList<LEGAL> legalMoves(pos);
        count = 0;
        bool foundBanned = false;
        for (const auto& m : legalMoves) {
            if (m == banMove) {
                foundBanned = true;
                std::cout << "[BANNED:" << UCI::move(pos, m) << "] ";
            } else {
                std::cout << UCI::move(pos, m) << " ";
            }
            if (++count % 10 == 0) std::cout << "\n";
        }
        std::cout << "\n\nBanned move " << (foundBanned ? "WAS" : "was NOT") << " found in move list (should be filtered)\n";
        
        // Make a move
        Move whiteMove = UCI::to_move(pos, "d2d4");
        if (whiteMove != MOVE_NONE) {
            StateInfo moveSt;
            std::cout << "\nWhite plays: d2d4\n";
            pos.do_move(whiteMove, moveSt);
            
            std::cout << "After move:\n";
            std::cout << "Ban Chess ply: " << pos.ban_chess_ply() << "\n";
            std::cout << "Is ban ply: " << (pos.is_ban_ply() ? "Yes" : "No") << "\n";
            std::cout << "Is move ply: " << (pos.is_move_ply() ? "Yes" : "No") << "\n";
            std::cout << "Banned move: " << (pos.banned_move() == MOVE_NONE ? "None" : UCI::move(pos, pos.banned_move())) << "\n";
            std::cout << "Side to move: " << (pos.side_to_move() == WHITE ? "White" : "Black") << "\n";
        }
    }
    
    std::cout << "\nTest completed!\n";
    return 0;
}