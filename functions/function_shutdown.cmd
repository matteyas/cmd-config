@echo off
setlocal EnableDelayedExpansion

set logfile=%logspath%\function_shutdown.log

set _mode=%~1

if not defined _mode (
  echo One argument necessary: _mode ^(off, hib, zzz, reboot, adv, uefi, abort^)
  echo Second argument ^(_timeout^) is optional, defaults to 120; none or 0 gives no _timeout
  exit /b
)

shift /1
set _time=%~1

shift /1
set _force=%~1
if defined _force (set _force= /f)

:: special _time
if "!_time!"=="none" (set _time=0)
if "!_time!"=="now"  (set _time=0)

:: default 120
if not defined _time (set _time=120)

:: note that%_force%is implied if !_time! > 0
set msg=
set cmd=
if "!_mode!"=="off"    (set cmd=shutdown /hybrid /s%_force% /_time !_time! /c " "
                       set msg=Power off)

if "!_mode!"=="hib"    (set cmd=shutdown /h%_force% /_time !_time! /c " "
                       set msg=Hibernate)

if "!_mode!"=="reboot" (set cmd=shutdown /r%_force% /_time !_time! /c " "
                       set msg=Reboot)

if "!_mode!"=="adv"    (set cmd=shutdown /r /o%_force% /_time !_time! /c " "
                       set msg=Entering advanced ^(windows^) boot menu and restarting)

if "!_mode!"=="uefi"   (set cmd=shutdown /r /fw%_force% /_time !_time! /c " "
                       set msg=Entering BIOS / UEFI after restart, )

if "!_mode!"=="zzz"    (set cmd=cscript //nologo %toolspath%\start_invisible.vbs %toolspath%\cmd-config-sleep.exe !_time!
                       set msg=Sleep)

:: note that in abort _mode, cmd=exit /b simply cancels the last echo; prior power requests will be removed as expected
if "!_mode!"=="abort"  (set cmd=exit /b)

:: any prior scheduled power requests are removed
if defined cmd (
  2>nul >nul shutdown /a
  if errorlevel 1 (echo:>nul) else (echo Previously scheduled power request cancelled)
  2>nul >nul taskkill%_force% /IM cmd-config-sleep.exe
  if errorlevel 1 (echo:>nul) else (echo Previously scheduled sleep request cancelled)
) else (
  echo Non-supported _mode: !_mode!
  exit /b
)

%cmd% 2>>%logfile% >nul

if errorlevel 1 (
  echo Command failed: %cmd%
  echo See %logfile% for more details.
  echo %cmd%>>%logfile%
) else (
  if defined msg (echo !msg! in !_time! seconds)
)