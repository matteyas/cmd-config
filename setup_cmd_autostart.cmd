@echo off
setlocal enableDelayedExpansion

cd /d %~dp0

(
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Command Processor" /v Autorun /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Command Processor" /v Autorun /d \"%cd%\init.cmd\"
mkdir logs
) >nul 2>nul

:: Generate init.cmd
(
echo:@echo off
echo:
echo::: Internal init
echo:set aliaspath=%cd%
echo:set functionpath=%cd%\functions
echo:set toolpath=%cd%\tools
echo:set logpath=%cd%\logs
echo:
echo::: Setup prompt
echo:set PROMPT=$P$_# 
echo:
echo::: Vars
echo:set PATH=%%path%%;C:\Program Files\Sublime Text 3;%%aliaspath%%;%%functionpath%%;%%toolspath%%
echo:
echo:set ethname=ethernet_main
echo:set stdip=192.168.10.123
echo:set stdrtr=192.168.10.1
echo:set stdmask=255.255.255.0
echo:
echo::: Macros
echo:if exist %%aliaspath%%\macros.txt (doskey /MACROFILE=%%aliaspath%%\macros.txt^)
echo:if exist %%aliaspath%%\private_macros.txt (doskey /MACROFILE=%%aliaspath%%\private_macros.txt^)
echo:
echo::: Powershell-based aliases
echo:set ps=powershell.exe -nologo -noprofile -command
echo:doskey ps=%%ps%% $*
echo:doskey dl=if not "$1"=="" (if not "$2"=="" (%%ps%% "Invoke-WebRequest $1 -OutFile $2"^) else (%%ps%% "Invoke-WebRequest $1 -OutFile webdl.out"^)^) else (echo Please provide at least 1 argument.^)
echo:
echo::: Setup marked locations
echo:if exist %%aliaspath%%\marks.txt (
echo:	for /f "usebackq" %%%%i in ("%%aliaspath%%\marks.txt"^) do (set %%%%i^)
echo:^)
echo:
echo::: Return to previous directory (obnoxious implementation due to previously auto-deleting the last_dir.txt file^)
echo:if exist %%aliaspath%%\last_dir.txt (
echo:	set /p last_dir=^<%%aliaspath%%\last_dir.txt
echo:^)
echo:
echo:if defined last_dir (
echo:	cd /d %%last_dir%%
echo:^)
echo:
echo:@echo on
) >init.cmd