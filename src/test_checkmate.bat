@echo off
echo Testing Ban Chess checkmate with only legal move banned
echo.
echo Test 1: Position where black king has only one escape square
echo Position: 7k/5Q2/8/8/8/8/8/7K w - - 0 1 moves f7g7 (Queen gives check)
echo Black king can only move to g8
echo.
(
echo uci
echo setoption name UCI_Variant value banchess
echo position fen 7k/5Q2/8/8/8/8/8/7K w - - 0 1 moves f7g7
echo d
echo showbans
echo ban h8g8
echo showbans
echo go depth 1
echo quit
) | stockfish.exe