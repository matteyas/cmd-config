@echo off
setlocal EnableDelayedExpansion EnableExtensions

if [%1]==[] (goto help)
if "%1"=="?" (goto help)
if "%1"=="/?" (goto help)
if "%1"=="-?" (goto help)
if "%1"=="--help" (goto help)
if "%1"=="-h" (goto help)

goto try_arguments

:help
echo USAGE:
echo function_sleep_then_call {time to sleep}^[range: 0-99999^] {command to run}
echo.
echo The following example outputs donkey to c:\out.txt after waiting 5 seconds in a background task
echo function_sleep_then_call 5 echo donkey^>c:\out.txt

goto :end

:try_arguments
if %1==bgtask (
  timeout %2
  cmd /c %3
) else ( start /B "" >nul cmd /c !functionpath!\function_sleep_then_call.cmd bgtask %* )

:end
@echo on