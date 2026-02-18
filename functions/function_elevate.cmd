@echo off

:init
 setlocal DisableDelayedExpansion
 set "batchPath=%~f0"
 set "from=%cd%"
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 set "elevation_grasped=%temp%\elevation_grasped.tmp"
 set "is_elevated=%temp%\is_elevated.tmp"
 setlocal EnableDelayedExpansion

:: first run
set grasping=
if not exist %elevation_grasped% (
  set grasping=1
  echo:>%elevation_grasped%
)

:checkPrivileges
  FSUTIL dirty query %SystemDrive% >nul
  if '%errorlevel%' == '0' (
    if defined grasping (
      echo Already elevated.
    )
    goto :end
  ) else (goto :getPrivileges)

:getPrivileges
  Echo Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  Echo UAC.ShellExecute "cmd", "/k echo:^>!is_elevated! ^& ""!batchPath!"" ^& cd /d %from%", "", "runas", 1 >> "%vbsGetPrivileges%"

  start /wait "" cscript "%vbsGetPrivileges%"
  goto :finally

:finally
  :: handle non-elevated prompt, close it if elevation succeeded, timeout needed to wait for file io from elevation vb-script
  timeout /t 1 >nul
  if exist %is_elevated% (
    del %is_elevated%
    exit
  ) else (
    echo Cancelled.
  )

:end
  :: cleanup
  del %elevation_grasped% >nul 2>nul
  del %vbsGetPrivileges% >nul 2>nul