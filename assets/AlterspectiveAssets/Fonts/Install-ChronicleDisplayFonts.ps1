# Install Chronicle Display Fonts (User-level installation - No admin required)
# Works on Windows 10 and later

$ErrorActionPreference = "Stop"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$fontFolder = Join-Path $scriptPath "chronicle-display"
$userFontsPath = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
$fontRegistryPath = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

Write-Host "=== Chronicle Display Font Installer ===" -ForegroundColor Cyan
Write-Host "Installing fonts for current user (no admin required)..." -ForegroundColor Yellow
Write-Host ""

# Create user fonts folder if it doesn't exist
if (-not (Test-Path $userFontsPath)) {
    New-Item -Path $userFontsPath -ItemType Directory -Force | Out-Null
    Write-Host "Created user fonts directory: $userFontsPath" -ForegroundColor Green
}

# Check if font folder exists
if (-not (Test-Path $fontFolder)) {
    Write-Host "ERROR: Font folder not found: $fontFolder" -ForegroundColor Red
    Write-Host "Please ensure the 'chronicle-display' folder is in the same directory as this script." -ForegroundColor Red
    Read-Host "`nPress Enter to exit"
    exit 1
}

# Get all OTF font files
$fontFiles = Get-ChildItem -Path $fontFolder -Filter "*.otf" -ErrorAction SilentlyContinue

if ($fontFiles.Count -eq 0) {
    Write-Host "ERROR: No .otf font files found in: $fontFolder" -ForegroundColor Red
    Read-Host "`nPress Enter to exit"
    exit 1
}

$installedCount = 0
$skippedCount = 0

foreach ($fontFile in $fontFiles) {
    $fontPath = $fontFile.FullName
    $fontName = $fontFile.Name
    $destPath = Join-Path $userFontsPath $fontName

    # Get font display name (without extension)
    $fontDisplayName = $fontFile.BaseName + " (OpenType)"

    try {
        # Check if font file already exists in user fonts
        $fontFileExists = Test-Path $destPath

        # Check if font is registered in registry
        $existingFont = Get-ItemProperty -Path $fontRegistryPath -Name $fontDisplayName -ErrorAction SilentlyContinue

        if ($existingFont -and $fontFileExists) {
            Write-Host "[OK] $fontDisplayName (already installed)" -ForegroundColor Green
            $skippedCount++
            continue
        }

        # Copy font to user fonts folder (only if not exists or can be overwritten)
        if (-not $fontFileExists) {
            Copy-Item -Path $fontPath -Destination $destPath -Force
        }

        # Register font in user registry (only if not already registered)
        if (-not $existingFont) {
            New-ItemProperty -Path $fontRegistryPath -Name $fontDisplayName -Value $destPath -PropertyType String -Force | Out-Null
        }

        Write-Host "[OK] Installed: $fontDisplayName" -ForegroundColor Green
        $installedCount++
    }
    catch {
        # Check if it's already installed despite the error
        $fontFileExists = Test-Path $destPath
        $existingFont = Get-ItemProperty -Path $fontRegistryPath -Name $fontDisplayName -ErrorAction SilentlyContinue

        if ($existingFont -and $fontFileExists) {
            Write-Host "[OK] $fontDisplayName (already installed)" -ForegroundColor Green
            $skippedCount++
        } else {
            Write-Host "[ERROR] Failed to install $fontDisplayName : $_" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "=== Installation Complete ===" -ForegroundColor Cyan
Write-Host "Fonts installed: $installedCount" -ForegroundColor Green
Write-Host "Fonts skipped: $skippedCount" -ForegroundColor Yellow
Write-Host ""
Write-Host "NOTE: You may need to restart applications (like PowerPoint) for fonts to appear." -ForegroundColor Yellow
Write-Host ""
Read-Host "Press Enter to exit"
