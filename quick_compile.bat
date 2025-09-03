@echo off
echo Quick Compile for Ban Chess Stockfish
echo =====================================
cd src

REM Set MinGW path
set PATH=C:\msys64\mingw64\bin;%PATH%

REM Create empty NNUE file if missing (to avoid assembler error)
if not exist nn-3475407dc199.nnue (
    echo. > nn-3475407dc199.nnue
)

echo.
echo Compiling core files...
g++ -c position.cpp -std=c++17 -O2 -DNDEBUG -DNNUE_EMBEDDING_OFF
g++ -c movegen.cpp -std=c++17 -O2 -DNDEBUG -DNNUE_EMBEDDING_OFF
g++ -c search.cpp -std=c++17 -O2 -DNDEBUG -DNNUE_EMBEDDING_OFF
g++ -c uci.cpp -std=c++17 -O2 -DNDEBUG -DNNUE_EMBEDDING_OFF
g++ -c main.cpp -std=c++17 -O2 -DNDEBUG -DNNUE_EMBEDDING_OFF

echo.
echo Linking...
g++ -o stockfish.exe *.o -static -lpthread

if exist stockfish.exe (
    echo.
    echo SUCCESS! stockfish.exe created
    dir stockfish.exe | findstr stockfish
) else (
    echo.
    echo Failed to create stockfish.exe
)
pause