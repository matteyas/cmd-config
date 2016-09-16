@echo off
setlocal

if not "%cd: =%"=="%cd%" (
	echo WARNING: It is strongly recommended to NOT have spaces in the path.
	choice /m "Still use this path? (probably works)"
	if errorlevel 2 (echo exiting... & exit /b) else (echo.)
)

2>nul >nul reg delete "HKCU\SOFTWARE\Microsoft\Command Processor" /v Autorun /f
2>nul >nul reg add "HKCU\SOFTWARE\Microsoft\Command Processor" /v Autorun /d "\"%cd%\init.cmd\" \"%cd%\""

if not errorlevel 1 (echo CMD Enviroment successfully setup.) else (echo Something went afuck.)