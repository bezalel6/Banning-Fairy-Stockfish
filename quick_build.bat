@echo off
cd src
set PATH=C:\msys64\mingw64\bin;%PATH%
mingw32-make build ARCH=x86-64-modern COMP=mingw LDFLAGS="-static" -j
echo.
echo Build complete. Check src\stockfish.exe
pause