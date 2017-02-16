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

cmd /c (@echo off) & for %%i in (!loop_expr!) do (%arg%)

@echo on