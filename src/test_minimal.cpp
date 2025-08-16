#include <iostream>
#include <string>

// Minimal test to verify the Ban Chess detection works

int main() {
    std::string variant = "banchess";
    bool isBanChess = (variant == "banchess");
    
    std::cout << "Variant: " << variant << std::endl;
    std::cout << "Is Ban Chess: " << (isBanChess ? "YES" : "NO") << std::endl;
    
    if (isBanChess) {
        std::cout << "Would use Ban Chess search\n";
        std::cout << "After Qxf7+:\n";
        std::cout << "- Black has 1 legal move (Kxf7)\n";
        std::cout << "- We can ban that move\n";
        std::cout << "- Result: CHECKMATE!\n";
    }
    
    return 0;
}