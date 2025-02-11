@echo off
rem ********************************************************************
rem EVERYTHING PORTABLE LAUNCHER - Fully Improved Version
rem ********************************************************************

rem Force launched processes to run with the invoker’s privileges.
set __COMPAT_LAYER=RunAsInvoker

rem Change to the directory where this script resides and set BASE_DIR.
cd /d "%~dp0"
set "BASE_DIR=%~dp0"

rem Enable delayed expansion.
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

:LoadConfig
rem Load settings from ini (if available) and set defaults.
if exist "%BASE_DIR%ini\settings.ini" (
    for /f "usebackq tokens=1,2 delims==" %%a in ("%BASE_DIR%ini\settings.ini") do (
        set "%%a=%%b"
    )
)
set "UserName=MarioMasta64"
set "NoPrompt=0"
set "arch=32"
if defined ProgramFiles(x86) set "arch=64"
exit /b

:DownloadFile
rem Download a file using PowerShell; exit on error.
powershell -Command "try { Invoke-WebRequest -Uri '%~1' -OutFile '%~2' -ErrorAction Stop } catch { exit 1 }"
if errorlevel 1 (
    echo Error downloading %~1
    exit /b 1
)
exit /b

:AutoInstall7Zip
rem Check for an existing 7-Zip command; if not found, download a portable version.
if defined ZIP_CMD exit /b
set "ZIP_CMD="
where 7za.exe >nul 2>&1 && set "ZIP_CMD=7za.exe"
if not defined ZIP_CMD (
    where 7z.exe >nul 2>&1 && set "ZIP_CMD=7z.exe"
)
if not defined ZIP_CMD (
    echo 7-Zip not found. Downloading portable version...
    if not exist "%BASE_DIR%tools" mkdir "%BASE_DIR%tools"
    call :DownloadFile "https://www.7-zip.org/a/7za920.zip" "%BASE_DIR%tools\7za920.zip"
    echo Extracting 7-Zip...
    powershell -Command "Expand-Archive -Path '%BASE_DIR%tools\7za920.zip' -DestinationPath '%BASE_DIR%tools\7za' -Force"
    if exist "%BASE_DIR%tools\7za\7za.exe" (
        echo 7-Zip successfully installed.
        set "ZIP_CMD=%BASE_DIR%tools\7za\7za.exe"
        set "PATH=%BASE_DIR%tools\7za;%PATH%"
    ) else (
        echo Failed to install 7-Zip.
        exit /b 1
    )
)
exit /b

:ExtractFile
call :AutoInstall7Zip
"%ZIP_CMD%" x "%~1" -o"%~2" -y >nul
exit /b

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
rem Uninstall then install/upgrade Epic Games.
call :UninstallEpicGames
call :UpgradeEpicGames
exit /b

:LaunchEpicGames
if not exist "%BASE_DIR%bin\epic_games\Launcher\Portal\Binaries\Win32\EpicGamesLauncher.exe" (
    echo Epic Games is not installed. Please run the installer first.
    pause
    exit /b
)
rem Adjust PATH for required DLLs.
if exist "%BASE_DIR%dll\%arch%\LauncherPrereqSetup_x%arch%.exe" (
    set "PATH=%PATH%;%BASE_DIR%dll\%arch%\"
) else (
    set "PATH=%PATH%;%BASE_DIR%dll\32\"
)
start "" "%BASE_DIR%bin\epic_games\Launcher\Portal\Binaries\Win32\EpicGamesLauncher.exe"
exit /b

:ResetEpicGames
echo Are you sure you want to reset Epic Games? Type YES to confirm:
set /p resp="Confirm: "
if /i not "%resp%"=="YES" exit /b
echo Resetting Epic Games...
pause
exit /b

:UninstallEpicGames
echo Uninstalling Epic Games...
taskkill /f /im EpicGamesLauncher.exe >nul 2>&1
pause
exit /b

:UpgradeEpicGames
echo Checking for Epic Games update...
call :DownloadFile "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi" "%BASE_DIR%EpicGamesLauncherInstaller.msi"
if not exist "%BASE_DIR%extra" mkdir "%BASE_DIR%extra"
move "%BASE_DIR%EpicGamesLauncherInstaller.msi" "%BASE_DIR%extra\EpicGamesLauncherInstaller.msi"
call :ExtractFile "%BASE_DIR%extra\EpicGamesLauncherInstaller.msi" "%BASE_DIR%temp"
xcopy "%BASE_DIR%temp\SourceDir\Epic Games\*" "%BASE_DIR%bin\epic_games\" /e /i /y >nul
rmdir /s /q "%BASE_DIR%temp"
exit /b

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
call :UninstallMinecraft
call :UpgradeMinecraft
exit /b

:LaunchMinecraft
if not exist "%BASE_DIR%bin\minecraft\bootstrap.exe" (
    echo Minecraft is not installed. Please run the installer first.
    pause
    exit /b
)
start "" "%BASE_DIR%bin\minecraft\bootstrap.exe"
exit /b

:ResetMinecraft
echo Are you sure you want to reset Minecraft? Type YES to confirm:
set /p resp="Confirm: "
if /i not "%resp%"=="YES" exit /b
echo Resetting Minecraft...
pause
exit /b

:UninstallMinecraft
echo Uninstalling Minecraft...
taskkill /f /im bootstrap.exe >nul 2>&1
pause
exit /b

:UpgradeMinecraft
echo Checking for Minecraft update...
call :DownloadFile "https://launcher.mojang.com/download/MinecraftInstaller.msi" "%BASE_DIR%MinecraftInstaller.msi"
if not exist "%BASE_DIR%extra" mkdir "%BASE_DIR%extra"
move "%BASE_DIR%MinecraftInstaller.msi" "%BASE_DIR%extra\MinecraftInstaller.msi"
call :ExtractFile "%BASE_DIR%extra\MinecraftInstaller.msi" "%BASE_DIR%bin\minecraft\"
move "%BASE_DIR%bin\minecraft\*Exe" "%BASE_DIR%bin\minecraft\bootstrap.exe"
pause
exit /b

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
if not exist "%BASE_DIR%bin\steam\steam.exe" (
    echo Steam is not installed.
    pause
    exit /b
)
if exist "%BASE_DIR%ini\steam.ini" (
    for /f "tokens=1,2 delims=:" %%a in ("%BASE_DIR%ini\steam.ini") do (
        if /i "%%a"=="User" set "steamUser=%%b"
        if /i "%%a"=="Pass" set "steamPass=%%b"
    )
    pushd "%BASE_DIR%bin\steam\"
    start "" "steam.exe" -login "!steamUser!" "!steamPass!"
    popd
) else (
    pushd "%BASE_DIR%bin\steam\"
    start "" "steam.exe"
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
pause
exit /b

:UpgradeSteam
echo Checking for Steam update...
call :DownloadFile "https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe" "%BASE_DIR%SteamSetup.exe"
if errorlevel 1 (
    echo Failed to download Steam installer.
    pause
    exit /b
)
if not exist "%BASE_DIR%extra" mkdir "%BASE_DIR%extra"
move /Y "%BASE_DIR%SteamSetup.exe" "%BASE_DIR%extra\SteamSetup.exe"
if exist "%BASE_DIR%extra\SteamSetup.exe" (
    echo Running Steam installer...
    echo Full path: "%BASE_DIR%extra\SteamSetup.exe"
    rem --- Option 1: Silent install (try /S). Uncomment the next two lines to use silent mode.
    rem pushd "%BASE_DIR%extra"
    rem start "" "SteamSetup.exe" /S & popd
    rem --- Option 2: Non-silent install (remove /S) for debugging. Use this if the silent mode isn’t working.
    pushd "%BASE_DIR%extra"
    start "" "SteamSetup.exe"
    popd
    echo Steam installer should now be running.
) else (
    echo Steam installer not found.
)
pause
exit /b

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
if not exist "%BASE_DIR%bin\telegram\Telegram.exe" (
    echo Telegram is not installed.
    pause
    exit /b
)
start "" "%BASE_DIR%bin\telegram\Telegram.exe"
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
for /d %%i in ("%BASE_DIR%bin\telegram\*") do (
    if /i not "%%~nxi"=="tdata" rmdir /s /q "%%i"
)
pause
exit /b

:UpgradeTelegram
echo Checking for Telegram update...
call :DownloadFile "https://telegram.org/dl/desktop/win%arch%_portable" "%BASE_DIR%TelegramPortable.zip"
if not exist "%BASE_DIR%extra" mkdir "%BASE_DIR%extra"
move /Y "%BASE_DIR%TelegramPortable.zip" "%BASE_DIR%extra\TelegramPortable.zip"
call :ExtractFile "%BASE_DIR%extra\TelegramPortable.zip" "%BASE_DIR%bin\telegram\"
pause
exit /b

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

endlocal
