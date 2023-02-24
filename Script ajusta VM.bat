@echo off
set file=ips.txt
for /f "delims=" %%a in (%file%) do (
ping -n 2 %%a >nul
if errorlevel 1 (
echo %%a Offline dia %date% as %time% >> offline.log
) else (
psexec -n 2 \\%%a -h cmd /c reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v HideFastUserSwitching /t REG_DWORD /d 0 /f
if errorlevel 1 (
echo %%a PSExec Timeout dia %date% as %time% >> timeout.log
)
)
)
pause
