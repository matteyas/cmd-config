@echo off
setlocal EnableDelayedExpansion

set logfile=%logspath%\function_shutdown.log

set mode=%~1

if not defined mode (
  echo One argument necessary: mode ^(off, hib, zzz, reboot, adv, uefi, abort^)
  echo Second argument ^(timeout^) is optional, defaults to 120; none or 0 gives no timeout
  exit /b
)

shift /1
set time=%~1

shift /1
set force=%~1
if defined force (set force= /f)

:: special time
if "!time!"=="none" (set time=0)
if "!time!"=="now"  (set time=0)

:: default 120
if not defined time (set time=120)

:: note that%force%is implied if !time! > 0
set msg=
set cmd=
if "!mode!"=="off"    (set cmd=shutdown /hybrid /s%force% /time !time! /c " "
                       set msg=Power off)

if "!mode!"=="hib"    (set cmd=shutdown /h%force% /time !time! /c " "
                       set msg=Hibernate)

if "!mode!"=="reboot" (set cmd=shutdown /r%force% /time !time! /c " "
                       set msg=Reboot)

if "!mode!"=="adv"    (set cmd=shutdown /r /o%force% /time !time! /c " "
                       set msg=Entering advanced (windows) boot menu and restarting)

if "!mode!"=="uefi"   (set cmd=shutdown /r /fw%force% /time !time! /c " "
                       set msg=Entering advanced (windows) boot menu and restarting)

if "!mode!"=="zzz"    (set cmd=cscript //nologo %toolspath%\start_invisible.vbs %toolspath%\cmd-config-sleep.exe !time!
                       set msg=Sleep)

:: note that in abort mode, cmd=exit /b simply cancels the last echo; prior power requests will be removed as expected
if "!mode!"=="abort"  (set cmd=exit /b)

:: any prior scheduled power requests are removed
if defined cmd (
  2>nul >nul shutdown /a
  if errorlevel 1 (echo:>nul) else (echo Previously scheduled power request cancelled)
  2>nul >nul taskkill%force% /IM cmd-config-sleep.exe
  if errorlevel 1 (echo:>nul) else (echo Previously scheduled sleep request cancelled)
) else (
  echo Non-supported mode: !mode!
  exit /b
)

%cmd% 2>>%logfile% >nul

if errorlevel 1 (
  echo Command failed: %cmd%
  echo See %logfile% for more details.
  echo %cmd%>>%logfile%
) else (
  if defined msg (echo !msg! in !time! seconds)
)