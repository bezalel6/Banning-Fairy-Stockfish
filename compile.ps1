# Quick compile script for Ban Chess
$env:Path = "C:\msys64\mingw64\bin;C:\msys64\usr\bin;" + $env:Path
Set-Location src

Write-Host "Compiling Stockfish with Ban Chess..." -ForegroundColor Yellow

$files = @(
    "benchmark.cpp", "bitboard.cpp", "endgame.cpp", "evaluate.cpp",
    "main.cpp", "material.cpp", "misc.cpp", "movegen.cpp", "movepick.cpp",
    "partner.cpp", "pawns.cpp", "piece.cpp", "position.cpp", "psqt.cpp",
    "search.cpp", "thread.cpp", "timeman.cpp", "tt.cpp", "uci.cpp",
    "ucioption.cpp", "parser.cpp", "variant.cpp", "xboard.cpp", "zobrist.cpp",
    "syzygy\tbprobe.cpp", "nnue\evaluate_nnue.cpp", "nnue\features\half_ka_v2_hm.cpp"
)

$cmd = "g++ -o stockfish.exe -O2 -std=c++17 -static -lpthread " + ($files -join " ")
Invoke-Expression $cmd

if (Test-Path "stockfish.exe") {
    Write-Host "Success! stockfish.exe created" -ForegroundColor Green
    Write-Host "Testing Ban Chess..." -ForegroundColor Yellow
    Write-Output "uci`nsetoption name UCI_Variant value banchess`nquit" | .\stockfish.exe | Select-String "banchess"
} else {
    Write-Host "Compilation failed!" -ForegroundColor Red
}