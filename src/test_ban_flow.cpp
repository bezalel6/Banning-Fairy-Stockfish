/*
  Test program to verify Ban Chess flow
*/

#include <iostream>
#include <string>
#include "position.h"
#include "movegen.h"
#include "uci.h"

using namespace Stockfish;

int main() {
    std::cout << "Ban Chess Flow Test\n";
    std::cout << "===================\n\n";
    
    // Initialize tables
    Position::init();
    
    // Create a Ban Chess position
    StateInfo st;
    Position pos;
    
    // Set Ban Chess variant
    Options["UCI_Variant"] = std::string("banchess");
    auto v = variants.find("banchess")->second;
    pos.set(v, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", false, &st, nullptr);
    
    std::cout << "Starting position:\n" << pos << "\n";
    std::cout << "Ban Chess ply: " << pos.ban_chess_ply() << "\n";
    std::cout << "Is ban ply: " << (pos.is_ban_ply() ? "Yes" : "No") << "\n";
    std::cout << "Side to move: " << (pos.side_to_move() == WHITE ? "White" : "Black") << "\n";
    
    std::cout << "\n=== Ply 1: Ban Phase ===\n";
    std::cout << "Current player (" << (pos.side_to_move() == WHITE ? "White" : "Black") 
              << ") should ban opponent's move\n";
    
    // In ban ply, we generate opponent's moves
    MoveList<LEGAL> banCandidates(pos);
    std::cout << "Legal moves to ban: " << banCandidates.size() << "\n";
    
    // Let's ban e2e4
    std::string banStr = "e2e4";
    Move ban = UCI::to_move(pos, banStr);
    if (ban != MOVE_NONE) {
        StateInfo banSt;
        pos.do_ban(ban, banSt);
        std::cout << "\nBanned move: e2e4\n";
        std::cout << "After ban:\n";
        std::cout << "  Ban Chess ply: " << pos.ban_chess_ply() << "\n";
        std::cout << "  Is ban ply: " << (pos.is_ban_ply() ? "Yes" : "No") << "\n";
        std::cout << "  Side to move: " << (pos.side_to_move() == WHITE ? "White" : "Black") << "\n";
        std::cout << "  Current ban: " << UCI::move(pos, pos.banned_move()) << "\n";
    }
    
    std::cout << "\n=== Ply 2: Move Phase ===\n";
    std::cout << "Current player (" << (pos.side_to_move() == WHITE ? "White" : "Black") 
              << ") makes a move (cannot play banned move)\n";
    
    MoveList<LEGAL> legalMoves(pos);
    std::cout << "Legal moves available: " << legalMoves.size() << "\n";
    
    // Check if e2e4 is in the list (it shouldn't be)
    bool foundBanned = false;
    for (const auto& m : legalMoves) {
        if (m == ban) {
            foundBanned = true;
            break;
        }
    }
    std::cout << "Banned move in list: " << (foundBanned ? "ERROR - Yes!" : "Good - No") << "\n";
    
    // Make a different move
    std::string moveStr = "d2d4";
    Move whiteMove = UCI::to_move(pos, moveStr);
    if (whiteMove != MOVE_NONE) {
        StateInfo moveSt;
        pos.do_move(whiteMove, moveSt);
        std::cout << "\nWhite plays: d2d4\n";
        std::cout << "After move:\n";
        std::cout << "  Ban Chess ply: " << pos.ban_chess_ply() << "\n";
        std::cout << "  Is ban ply: " << (pos.is_ban_ply() ? "Yes" : "No") << "\n";
        std::cout << "  Side to move: " << (pos.side_to_move() == WHITE ? "White" : "Black") << "\n";
        std::cout << "  Current ban: " << (pos.banned_move() == MOVE_NONE ? "None" : UCI::move(pos, pos.banned_move())) << "\n";
    }
    
    std::cout << "\n=== Ply 3: Ban Phase Again ===\n";
    std::cout << "Current player (" << (pos.side_to_move() == WHITE ? "White" : "Black") 
              << ") should ban opponent's move\n";
    std::cout << "Ban Chess ply: " << pos.ban_chess_ply() << "\n";
    std::cout << "Is ban ply: " << (pos.is_ban_ply() ? "Yes" : "No") << "\n";
    
    return 0;
}