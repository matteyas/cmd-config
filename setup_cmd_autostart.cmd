@echo off
setlocal enableDelayedExpansion

>nul reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Command Processor" /v Autorun /f
>nul reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Command Processor" /v Autorun /d \"%cd%\init.cmd\"

set c=0
del init.tmp
for /f "tokens=1* delims=]" %%A in ('type "init.cmd" ^| find /n /v ""') do (
	set /a c+=1
	if not !c! equ 1 (
	if not !c! equ 5 (echo.%%B>>init.tmp) else (echo set aliaspath=%cd%>>init.tmp)
	)
)
if exist init.tmp (del init.cmd)
ren init.tmp init.cmd
@echo on