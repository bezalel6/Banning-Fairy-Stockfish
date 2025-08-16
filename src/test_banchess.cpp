#include <iostream>
#include <string>

// Simple test to verify Ban Chess logic
// After Qxf7+, Black has only 1 legal move: Kxf7
// If White bans Kxf7, it's checkmate

int main() {
    std::cout << "Ban Chess Checkmate Test\n";
    std::cout << "========================\n\n";
    
    std::cout << "Position after 1.e4 e6 2.Qh5 a5 3.Qxf7+:\n";
    std::cout << "Black is in check from Queen on f7\n";
    std::cout << "Black's legal moves: Kxf7 (only move)\n\n";
    
    std::cout << "Ban Chess evaluation:\n";
    std::cout << "- If White bans Kxf7: Black has NO legal moves = CHECKMATE\n";
    std::cout << "- Therefore, Qxf7+ is a forced checkmate in Ban Chess\n\n";
    
    std::cout << "Expected engine behavior:\n";
    std::cout << "1. Recognize Qxf7+ gives check with only one legal response\n";
    std::cout << "2. Evaluate that banning the only response leads to checkmate\n";
    std::cout << "3. Return Qxf7+ as the best move with mate score\n\n";
    
    std::cout << "Current issue: The Ban Chess search implementation exists but\n";
    std::cout << "isn't properly evaluating future ban possibilities during search.\n";
    
    return 0;
}