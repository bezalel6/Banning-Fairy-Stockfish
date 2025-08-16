@echo off
echo Testing Ban Chess with Qxf7+ checkmate position
echo.
cd src
echo uci > test_commands.txt
echo setoption name UCI_Variant value banchess >> test_commands.txt
echo position fen rnbqkbnr/1pppp1pp/4p3/p6Q/4P3/8/PPPP1PPP/RNB1KBNR w KQkq - 0 3 >> test_commands.txt
echo go depth 10 >> test_commands.txt
echo quit >> test_commands.txt

stockfish.exe < test_commands.txt | findstr /C:"bestmove"
echo.
echo Expected: bestmove h5f7 (Qxf7+ leading to checkmate)
del test_commands.txt