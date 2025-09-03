@echo off
REM Build script for Fairy-Stockfish with Ban Chess
REM Can be run from any Windows terminal (CMD, PowerShell, Git Bash)

echo ========================================
echo Fairy-Stockfish Windows Build Script
echo ========================================
echo.

REM Check if MSYS2 is installed
if not exist "C:\msys64\mingw64\bin\g++.exe" (
    echo ERROR: MSYS2 MinGW64 not found!
    echo Please install MSYS2 from https://www.msys2.org/
    echo Or adjust the path in this script if installed elsewhere
    exit /b 1
)

REM Set up environment variables for MinGW64
set PATH=C:\msys64\mingw64\bin;C:\msys64\usr\bin;%PATH%
set MSYSTEM=MINGW64
set CC=gcc
set CXX=g++

REM Navigate to src directory
cd /d "%~dp0\src"

REM Parse arguments
set BUILD_TYPE=%1
if "%BUILD_TYPE%"=="" set BUILD_TYPE=build

set ARCH=%2
if "%ARCH%"=="" set ARCH=x86-64-modern

echo Build type: %BUILD_TYPE%
echo Architecture: %ARCH%
echo.

REM Clean old files if requested
if "%BUILD_TYPE%"=="clean" (
    echo Cleaning build files...
    del /f /q *.o 2>nul
    del /f /q *.exe 2>nul
    echo Clean complete!
    exit /b 0
)

REM Build the engine
echo Building Fairy-Stockfish...
echo.

REM Use mingw32-make from MSYS2
C:\msys64\mingw64\bin\mingw32-make.exe -j %BUILD_TYPE% ARCH=%ARCH% COMP=mingw LDFLAGS="-static"

REM Check if build succeeded
if exist stockfish.exe (
    echo.
    echo ========================================
    echo Build successful!
    echo Output: src\stockfish.exe
    echo Size: 
    dir /b stockfish.exe | find "stockfish.exe"
    echo.
    echo Test with: src\stockfish.exe bench
    echo ========================================
) else (
    echo.
    echo ========================================
    echo Build failed! No executable created.
    echo Try running: build.bat clean
    echo Then: build.bat
    echo ========================================
    exit /b 1
)