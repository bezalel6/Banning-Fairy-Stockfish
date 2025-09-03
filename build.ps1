# PowerShell build script for Fairy-Stockfish with Ban Chess
# Can be run from PowerShell with: .\build.ps1

param(
    [string]$BuildType = "build",
    [string]$Arch = "x86-64-modern",
    [switch]$Clean,
    [switch]$Test,
    [switch]$Quick
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Fairy-Stockfish PowerShell Build Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if MSYS2 is installed
$msys2Path = "C:\msys64"
if (-not (Test-Path "$msys2Path\mingw64\bin\g++.exe")) {
    Write-Host "ERROR: MSYS2 MinGW64 not found!" -ForegroundColor Red
    Write-Host "Please install MSYS2 from https://www.msys2.org/" -ForegroundColor Yellow
    exit 1
}

# Set up environment
$env:PATH = "$msys2Path\mingw64\bin;$msys2Path\usr\bin;" + $env:PATH
$env:MSYSTEM = "MINGW64"

# Navigate to script directory then to src
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location "$scriptPath\src"

# Clean if requested
if ($Clean) {
    Write-Host "Cleaning build files..." -ForegroundColor Yellow
    Remove-Item *.o -Force -ErrorAction SilentlyContinue
    Remove-Item *.exe -Force -ErrorAction SilentlyContinue
    Write-Host "Clean complete!" -ForegroundColor Green
    if (-not $BuildType -eq "build") { exit 0 }
}

# Quick build using direct g++ (faster for development)
if ($Quick) {
    Write-Host "Quick build mode (no optimization)..." -ForegroundColor Yellow
    $files = @(
        "benchmark.cpp", "bitboard.cpp", "endgame.cpp", "evaluate.cpp",
        "main.cpp", "material.cpp", "misc.cpp", "movegen.cpp", "movepick.cpp",
        "partner.cpp", "pawns.cpp", "piece.cpp", "position.cpp", "psqt.cpp",
        "search.cpp", "thread.cpp", "timeman.cpp", "tt.cpp", "uci.cpp",
        "ucioption.cpp", "parser.cpp", "variant.cpp", "xboard.cpp", "zobrist.cpp",
        "syzygy\tbprobe.cpp", "nnue\evaluate_nnue.cpp", "nnue\features\half_ka_v2_hm.cpp"
    )
    
    $cmd = "g++ -o stockfish.exe -O2 -std=c++17 -static " + ($files -join " ") + " -lpthread"
    Write-Host "Compiling..." -ForegroundColor Yellow
    Invoke-Expression $cmd
} else {
    # Full build using make
    Write-Host "Build type: $BuildType" -ForegroundColor Green
    Write-Host "Architecture: $Arch" -ForegroundColor Green
    Write-Host ""
    Write-Host "Building Fairy-Stockfish..." -ForegroundColor Yellow
    
    $makeCmd = "$msys2Path\mingw64\bin\mingw32-make.exe"
    $makeArgs = "-j", $BuildType, "ARCH=$Arch", "COMP=mingw", 'LDFLAGS="-static"'
    
    & $makeCmd $makeArgs
}

# Check if build succeeded
if (Test-Path "stockfish.exe") {
    $size = (Get-Item "stockfish.exe").Length / 1MB
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Build successful!" -ForegroundColor Green
    Write-Host "Output: src\stockfish.exe" -ForegroundColor Green
    Write-Host ("Size: {0:N2} MB" -f $size) -ForegroundColor Green
    
    if ($Test) {
        Write-Host ""
        Write-Host "Running bench test..." -ForegroundColor Yellow
        & ".\stockfish.exe" bench
    } else {
        Write-Host ""
        Write-Host "Test with: .\stockfish.exe bench" -ForegroundColor Cyan
    }
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Build failed! No executable created." -ForegroundColor Red
    Write-Host "Try running: .\build.ps1 -Clean" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Red
    exit 1
}