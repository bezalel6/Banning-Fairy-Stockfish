@echo off
echo Ban Chess Test Suite
echo ====================
echo.

cd src

echo Test 1: Basic Ban Chess Setup
echo ------------------------------
echo uci | stockfish.exe | findstr /i "banchess"
echo.

echo Test 2: Starting Position
echo -------------------------
(
echo uci
echo setoption name UCI_Variant value banchess
echo position startpos
echo d
echo quit
) | stockfish.exe | findstr /i "ply"

echo.
echo Test 3: Simple Game Sequence
echo -----------------------------
echo Testing: Black bans e2e4, White plays d2d4
(
echo uci
echo setoption name UCI_Variant value banchess
echo position startpos moves e2e4 d2d4
echo d
echo quit
) | stockfish.exe | findstr /i "fen"

echo.
echo Test 4: Engine Analysis at Depth 3
echo -----------------------------------
(
echo uci
echo setoption name UCI_Variant value banchess
echo position startpos
echo go depth 3
echo quit
) | stockfish.exe | findstr "bestmove"

echo.
echo Tests complete!
pause