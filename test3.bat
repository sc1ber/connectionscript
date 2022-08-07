@setlocal enableextensions enabledelayedexpansion
@echo off
if EXIST output.txt del output.txt
echo Date:%date% Time:%time% >> output.txt
for /F "tokens=* delims=" %%x in (input.txt) DO (
	echo %%x|find "//" >nul
	if errorlevel 1 (
		ping -4 -n 1 %%x | find /i "TTL" > nul
		if !errorlevel!==0 (set state=UP) else (set state=DOWN)
		echo %%x is !state!
		echo %%x - !state! >> output.txt
	) else (echo %%x >> output.txt)
)
echo Output is saved in: output.txt
pause
endlocal
