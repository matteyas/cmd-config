@echo off
setlocal EnableDelayedExpansion EnableExtensions

set fail=
set loop_expr=%1
if not defined loop_expr (set fail=1)
shift
set arg=%1
if not defined arg (set fail=1)

if defined fail (
	echo ERROR, this command takes at least two arguments, file-pattern and command to execute
	exit /b
)
:parse_arg
shift
set temp=%1
if defined temp (
	set arg=!arg! !temp!
	goto :parse_arg
)

:: Handle pipes / redirections
set arg=!arg:-a-=^>^>!
set arg=!arg:-o-=^>!
set arg=!arg:-append-=^>^>!
set arg=!arg:-out-=^>!
set arg=!arg:-/-=^|!
set arg=!arg:-pipe-=^|!
set arg=!arg:-and-=^&!
set arg=!arg:-+-=^&!

cmd /c (@echo off) & for /D %%i in (!loop_expr!) do (%arg%)

@echo on