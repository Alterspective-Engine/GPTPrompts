@echo off
:: Alterspective - Chronicle Display Font Installer
:: Double-click this file to install the fonts

echo.
echo ========================================
echo  Alterspective Font Installer
echo ========================================
echo.
echo This will install Chronicle Display fonts for your user account.
echo No administrator privileges required.
echo.
pause

:: Run PowerShell script
powershell.exe -ExecutionPolicy Bypass -File "%~dp0Install-ChronicleDisplayFonts.ps1"

echo.
echo Installation process completed.
echo.
echo IMPORTANT: Please close and restart any open applications
echo (PowerPoint, Word, etc.) to see the newly installed fonts.
echo.
pause
