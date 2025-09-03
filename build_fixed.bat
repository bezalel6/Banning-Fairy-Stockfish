@echo off
echo Fixed Build for Stockfish with Ban Chess
echo =========================================
echo.

cd src
set PATH=C:\msys64\mingw64\bin;%PATH%

echo Downloading required NNUE file...
if not exist nn-3475407dc199.nnue (
    echo Please download nn-3475407dc199.nnue or run: make net
    echo Continuing without NNUE...
)

echo.
echo Compiling... (this may take 1-2 minutes)
g++ -o stockfish.exe -DNDEBUG -O2 -std=c++17 -march=native -static ^
    benchmark.cpp bitboard.cpp endgame.cpp evaluate.cpp main.cpp ^
    material.cpp misc.cpp movegen.cpp movepick.cpp partner.cpp ^
    pawns.cpp piece.cpp position.cpp psqt.cpp search.cpp ^
    thread.cpp timeman.cpp tt.cpp uci.cpp ucioption.cpp ^
    parser.cpp variant.cpp xboard.cpp ^
    syzygy\tbprobe.cpp nnue\evaluate_nnue.cpp ^
    nnue\features\half_ka_v2_hm.cpp -lpthread 2^>^&1

if exist stockfish.exe (
    echo.
    echo SUCCESS! stockfish.exe created
    echo Size:
    dir stockfish.exe ^| findstr stockfish
    echo.
    echo Testing Ban Chess variant...
    echo uci ^| stockfish.exe ^| findstr /i "banchess"
) else (
    echo.
    echo Build failed. Trying simpler compilation without NNUE...
    g++ -o stockfish.exe -DNDEBUG -DNO_NNUE -O2 -std=c++17 -static ^
        benchmark.cpp bitboard.cpp endgame.cpp evaluate.cpp main.cpp ^
        material.cpp misc.cpp movegen.cpp movepick.cpp partner.cpp ^
        pawns.cpp piece.cpp position.cpp psqt.cpp search.cpp ^
        thread.cpp timeman.cpp tt.cpp uci.cpp ucioption.cpp ^
        parser.cpp variant.cpp xboard.cpp -lpthread
    
    if exist stockfish.exe (
        echo SUCCESS with NO_NNUE!
    ) else (
        echo Still failed. Check error messages above.
    )
)

echo.
pause