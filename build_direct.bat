@echo off
echo Direct Build for Stockfish with Ban Chess
echo =========================================
echo.

cd src
set PATH=C:\msys64\mingw64\bin;%PATH%

echo Compiling... (this may take a minute)
g++ -o stockfish.exe -DNDEBUG -O2 -std=c++17 -static ^
    benchmark.cpp bitboard.cpp endgame.cpp evaluate.cpp main.cpp ^
    material.cpp misc.cpp movegen.cpp movepick.cpp partner.cpp ^
    pawns.cpp piece.cpp position.cpp psqt.cpp search.cpp ^
    thread.cpp timeman.cpp tt.cpp uci.cpp ucioption.cpp ^
    parser.cpp variant.cpp xboard.cpp zobrist.cpp ^
    syzygy\tbprobe.cpp nnue\evaluate_nnue.cpp ^
    nnue\features\half_ka_v2_hm.cpp -lpthread

if exist stockfish.exe (
    echo.
    echo SUCCESS! stockfish.exe created
    echo Size:
    dir stockfish.exe | findstr stockfish
) else (
    echo.
    echo FAILED! No executable created.
    echo Try running this from a regular Command Prompt, not PowerShell.
)

echo.
pause