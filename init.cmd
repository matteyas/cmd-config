@echo off

:: Internal init
set aliaspath=c:\cmdAliases

:: Setup commands
doskey alias=notepad %aliaspath%\init.cmd
doskey setup=notepad %aliaspath%\init.cmd
doskey macro=notepad %aliaspath%\macros.txt
doskey macros=notepad %aliaspath%\macros.txt

:: Setup prompt
set PROMPT=$P$_# 

:: Vars
set PATH=%path%;C:\Program Files\Sublime Text 3;%aliaspath%

set ethname=ethernet_main
set stdip=192.168.10.123
set stdrtr=192.168.10.1
set stdmask=255.255.255.0

:: Aliases
doskey /MACROFILE=%aliaspath%\macros.txt

:: Powershell-based aliases
set ps=powershell.exe -nologo -noprofile -command
doskey ps=%ps% $*
doskey dl=if not "$1"=="" (if not "$2"=="" (%ps% "Invoke-WebRequest $1 -OutFile $2") else (%ps% "Invoke-WebRequest $1 -OutFile webdl.out")) else (echo Please provide at least 1 argument.)

:: Setup marked locations
if exist %aliaspath%\marks.txt (
	for /f "usebackq" %%i in ("%aliaspath%\marks.txt") do (set %%i)
)

:: Return to previous directory (obnoxious implementation due to previously auto-deleting the last_dir.txt file)
if exist %aliaspath%\last_dir.txt (
	set /p last_dir=<%aliaspath%\last_dir.txt
)

if defined last_dir (
	cd /d %last_dir%
)

@echo on
