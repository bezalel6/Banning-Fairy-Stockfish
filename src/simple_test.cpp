// Simple test to verify Ban Chess ply logic
#include <iostream>

class SimpleBanChess {
public:
    int banChessPly;
    bool banchess;
    
    SimpleBanChess() : banChessPly(1), banchess(true) {}
    
    bool is_ban_ply() const {
        if (!banchess) return false;
        return (banChessPly % 2) == 1;
    }
    
    bool is_move_ply() const {
        if (!banchess) return false;
        return (banChessPly % 2) == 0;
    }
    
    void do_ban() {
        std::cout << "Ply " << banChessPly << ": Ban phase - opponent selects ban\n";
        banChessPly++;
    }
    
    void do_move() {
        std::cout << "Ply " << banChessPly << ": Move phase - player moves\n";
        banChessPly++;
    }
    
    void show_state() {
        std::cout << "  Current ply: " << banChessPly;
        std::cout << " | Phase: " << (is_ban_ply() ? "BAN" : "MOVE") << "\n";
    }
};

int main() {
    std::cout << "Ban Chess Ply System Test\n";
    std::cout << "=========================\n\n";
    
    SimpleBanChess game;
    
    for (int i = 0; i < 8; i++) {
        game.show_state();
        
        if (game.is_ban_ply()) {
            game.do_ban();
        } else {
            game.do_move();
        }
        std::cout << "\n";
    }
    
    return 0;
}