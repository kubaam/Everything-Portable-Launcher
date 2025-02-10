@echo off
rem ==============================================================================
rem EVERYTHING PORTABLE LAUNCHER
rem Made and maintained by Ambry
rem ==============================================================================
setlocal EnableDelayedExpansion
call :LoadConfig

:MainMenu
cls
echo =============================================
echo      EVERYTHING PORTABLE LAUNCHER by Ambry
echo =============================================
echo 1. Epic Games Launcher
echo 2. Minecraft Launcher
echo 3. Steam Launcher
echo 4. Telegram Launcher
echo 5. Exit
echo =============================================
set /p mainchoice="Select an option: "

if "%mainchoice%"=="1" call :EpicGamesMenu
if "%mainchoice%"=="2" call :MinecraftMenu
if "%mainchoice%"=="3" call :SteamMenu
if "%mainchoice%"=="4" call :TelegramMenu
if "%mainchoice%"=="5" exit /b

goto MainMenu

::--------------------------------------------------------------------
:: Load configuration settings from an INI file (if present)
::--------------------------------------------------------------------
:LoadConfig
rem Default settings:
set "UserName=MarioMasta64"
set "NoPrompt=0"
set "arch=32"
if exist ".\ini\settings.ini" (
    for /f "usebackq tokens=1,2 delims==" %%a in (".\ini\settings.ini") do (
        set "%%a=%%b"
    )
)
rem Detect architecture:
if defined ProgramFiles(x86) set "arch=64"
exit /b

::--------------------------------------------------------------------
:: Common file download routine (using PowerShell)
:: Usage: call :DownloadFile URL DestinationFile
::--------------------------------------------------------------------
:DownloadFile
powershell -Command "try { Invoke-WebRequest -Uri '%~1' -OutFile '%~2' -ErrorAction Stop } catch { exit 1 }"
if errorlevel 1 (
    echo Error downloading %~1
    exit /b 1
)
exit /b

::--------------------------------------------------------------------
:: Helper: Extract an MSI (or ZIP) file using 7-Zip (assumes 7z is in PATH)
:: Usage: call :ExtractFile SourceFile DestinationFolder
::--------------------------------------------------------------------
:ExtractFile
7z x "%~1" -o"%~2" -y >nul
exit /b

::--------------------------------------------------------------------
:: Epic Games Menu and routines
::--------------------------------------------------------------------
:EpicGamesMenu
cls
echo =============================================
echo         Epic Games Launcher Options
echo =============================================
echo 1. Reinstall / Install Epic Games
echo 2. Launch Epic Games
echo 3. Reset Epic Games
echo 4. Uninstall Epic Games
echo 5. Back to Main Menu
echo =============================================
set /p epchoice="Choice: "

if "%epchoice%"=="1" call :Reinstall_InstallEpicGames
if "%epchoice%"=="2" call :LaunchEpicGames
if "%epchoice%"=="3" call :ResetEpicGames
if "%epchoice%"=="4" call :UninstallEpicGames
if "%epchoice%"=="5" goto MainMenu
goto EpicGamesMenu

:Reinstall_InstallEpicGames
rem (Example: uninstall then upgrade)
call :UninstallEpicGames
call :UpgradeEpicGames
exit /b

:LaunchEpicGames
if not exist ".\bin\epic_games\Launcher\Portal\Binaries\Win32\EpicGamesLauncher.exe" (
    echo Epic Games is not installed. Please run the installer first.
    pause
    exit /b
)
rem Adjust PATH for DLLs if needed:
if exist ".\bin\epic_games\Launcher\Portal\Extras\Redist\LauncherPrereqSetup_x%arch%.exe" (
    set "PATH=%PATH%;%~dp0dll\%arch%\"
) else (
    set "PATH=%PATH%;%~dp0dll\32\"
)
start "" ".\bin\epic_games\Launcher\Portal\Binaries\Win32\EpicGamesLauncher.exe"
exit /b

:ResetEpicGames
echo Are you sure you want to reset Epic Games? Type YES to confirm:
set /p resp="Confirm: "
if /i not "%resp%"=="YES" exit /b
echo Resetting Epic Games...
rem (Insert reset commands here)
pause
exit /b

:UninstallEpicGames
echo Uninstalling Epic Games...
taskkill /f /im EpicGamesLauncher.exe >nul 2>&1
rem (Remove installation directories as needed)
pause
exit /b

:UpgradeEpicGames
echo Checking for Epic Games update...
call :DownloadFile "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi" "EpicGamesLauncherInstaller.msi"
move "EpicGamesLauncherInstaller.msi" ".\extra\EpicGamesLauncherInstaller.msi"
call :ExtractFile ".\extra\EpicGamesLauncherInstaller.msi" ".\temp"
xcopy ".\temp\SourceDir\Epic Games\*" ".\bin\epic_games\" /e /i /y >nul
rmdir /s /q ".\temp\"
exit /b

::--------------------------------------------------------------------
:: Minecraft Menu and routines
::--------------------------------------------------------------------
:MinecraftMenu
cls
echo =============================================
echo         Minecraft Launcher Options
echo =============================================
echo 1. Reinstall / Install Minecraft
echo 2. Launch Minecraft
echo 3. Reset Minecraft
echo 4. Uninstall Minecraft
echo 5. Back to Main Menu
echo =============================================
set /p mcchoice="Choice: "

if "%mcchoice%"=="1" call :Reinstall_InstallMinecraft
if "%mcchoice%"=="2" call :LaunchMinecraft
if "%mcchoice%"=="3" call :ResetMinecraft
if "%mcchoice%"=="4" call :UninstallMinecraft
if "%mcchoice%"=="5" goto MainMenu
goto MinecraftMenu

:Reinstall_InstallMinecraft
rem (Example: uninstall then upgrade)
call :UninstallMinecraft
call :UpgradeMinecraft
exit /b

:LaunchMinecraft
if not exist ".\bin\minecraft\bootstrap.exe" (
    echo Minecraft is not installed. Please run the installer first.
    pause
    exit /b
)
start "" ".\bin\minecraft\bootstrap.exe"
exit /b

:ResetMinecraft
echo Are you sure you want to reset Minecraft? Type YES to confirm:
set /p resp="Confirm: "
if /i not "%resp%"=="YES" exit /b
echo Resetting Minecraft...
rem (Reset commands here)
pause
exit /b

:UninstallMinecraft
echo Uninstalling Minecraft...
taskkill /f /im bootstrap.exe >nul 2>&1
rem (Remove installation directories if desired)
pause
exit /b

:UpgradeMinecraft
echo Checking for Minecraft update...
call :DownloadFile "https://launcher.mojang.com/download/MinecraftInstaller.msi" "MinecraftInstaller.msi"
move "MinecraftInstaller.msi" ".\extra\MinecraftInstaller.msi"
call :ExtractFile ".\extra\MinecraftInstaller.msi" ".\bin\minecraft\"
move ".\bin\minecraft\*Exe" ".\bin\minecraft\bootstrap.exe"
pause
exit /b

::--------------------------------------------------------------------
:: Steam Menu (example implementation)
::--------------------------------------------------------------------
:SteamMenu
cls
echo =============================================
echo           Steam Launcher Options
echo =============================================
echo 1. Reinstall / Install Steam
echo 2. Launch Steam
echo 3. Reset Steam
echo 4. Uninstall Steam
echo 5. Back to Main Menu
echo =============================================
set /p steamchoice="Choice: "
if "%steamchoice%"=="1" call :Reinstall_InstallSteam
if "%steamchoice%"=="2" call :LaunchSteam
if "%steamchoice%"=="3" call :ResetSteam
if "%steamchoice%"=="4" call :UninstallSteam
if "%steamchoice%"=="5" goto MainMenu
goto SteamMenu

:Reinstall_InstallSteam
call :UninstallSteam
call :UpgradeSteam
exit /b

:LaunchSteam
if not exist ".\bin\steam\steam.exe" (
    echo Steam is not installed.
    pause
    exit /b
)
if exist ".\ini\steam.ini" (
    for /f "tokens=1,2 delims=:" %%a in (".\ini\steam.ini") do (
        if /i "%%a"=="User" set "steamUser=%%b"
        if /i "%%a"=="Pass" set "steamPass=%%b"
    )
    pushd ".\bin\steam\"
    start steam.exe -login "!steamUser!" "!steamPass!"
    popd
) else (
    pushd ".\bin\steam\"
    start steam.exe
    popd
)
exit /b

:ResetSteam
echo Are you sure you want to reset Steam? Type YES to confirm:
set /p resp="Confirm: "
if /i not "%resp%"=="YES" exit /b
echo Resetting Steam...
pause
exit /b

:UninstallSteam
echo Uninstalling Steam...
taskkill /f /im steam.exe >nul 2>&1
rem (Remove directories if desired)
pause
exit /b

:UpgradeSteam
echo Checking for Steam update...
call :DownloadFile "https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe" "SteamSetup.exe"
move "SteamSetup.exe" ".\extra\SteamSetup.exe"
call :ExtractFile ".\extra\SteamSetup.exe" ".\bin\steam\"
pause
exit /b

::--------------------------------------------------------------------
:: Telegram Menu (example implementation)
::--------------------------------------------------------------------
:TelegramMenu
cls
echo =============================================
echo         Telegram Launcher Options
echo =============================================
echo 1. Reinstall / Install Telegram
echo 2. Launch Telegram
echo 3. Reset Telegram
echo 4. Uninstall Telegram
echo 5. Back to Main Menu
echo =============================================
set /p telchoice="Choice: "
if "%telchoice%"=="1" call :Reinstall_InstallTelegram
if "%telchoice%"=="2" call :LaunchTelegram
if "%telchoice%"=="3" call :ResetTelegram
if "%telchoice%"=="4" call :UninstallTelegram
if "%telchoice%"=="5" goto MainMenu
goto TelegramMenu

:Reinstall_InstallTelegram
call :UninstallTelegram
call :UpgradeTelegram
exit /b

:LaunchTelegram
if not exist ".\bin\telegram\Telegram.exe" (
    echo Telegram is not installed.
    pause
    exit /b
)
start "" ".\bin\telegram\Telegram.exe"
exit /b

:ResetTelegram
echo Are you sure you want to reset Telegram? Type YES to confirm:
set /p resp="Confirm: "
if /i not "%resp%"=="YES" exit /b
echo Resetting Telegram...
pause
exit /b

:UninstallTelegram
echo Uninstalling Telegram...
taskkill /f /im Telegram.exe >nul 2>&1
for /d %%i in (".\bin\telegram\*") do (
    if /i not "%%~nxi"=="tdata" rmdir /s /q "%%i"
)
pause
exit /b

:UpgradeTelegram
echo Checking for Telegram update...
call :DownloadFile "https://telegram.org/dl/desktop/win%arch%_portable" "TelegramPortable.zip"
move "TelegramPortable.zip" ".\extra\TelegramPortable.zip"
call :ExtractFile ".\extra\TelegramPortable.zip" ".\bin\telegram\"
pause
exit /b

::--------------------------------------------------------------------
:: Common Utility: PingInstall (example routine)
::--------------------------------------------------------------------
:PingInstall
for /F "skip=1 tokens=5" %%a in ('vol %~D0') do echo %%a>serial.txt
set /a count=1 
for /f "skip=1 delims=:" %%a in ('CertUtil -hashfile "serial.txt" sha1') do (
  if !count! equ 1 set "sha1=%%a"
  set /a count+=1
)
echo %sha1%
if exist serial.txt del serial.txt
exit /b

::--------------------------------------------------------------------
:: End of script
