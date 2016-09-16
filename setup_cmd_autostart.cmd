@echo off
setlocal

if not "%cd: =%"=="%cd%" (
	echo Currently only paths without spaces is supported because batch is amazing.
	echo exiting...
	exit /b
)

2>nul >nul reg delete "HKCU\SOFTWARE\Microsoft\Command Processor" /v Autorun /f
2>nul >nul reg add "HKCU\SOFTWARE\Microsoft\Command Processor" /v Autorun /d "\"%cd%\init.cmd\" \"%cd%\""

if not errorlevel 1 (echo CMD Enviroment successfully setup.) else (echo Something went afuck.)