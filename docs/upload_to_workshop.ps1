# =============================================
# Project Zomboid Workshop Upload (PowerShell)
# =============================================
#
# QUICK START (run in PowerShell 7+):
# 1) Temporarily allow script execution in this session:
#    Set-ExecutionPolicy -Scope Process Bypass -Force
# 2) Run interactively (SteamCMD prompts for password/Steam Guard):
#    pwsh -File .\docs\upload_to_workshop.ps1 -Username YOUR_STEAM_USERNAME
# 3) Run non-interactively (enter everything in this PS window):
#    pwsh -File .\docs\upload_to_workshop.ps1 -Username YOUR_STEAM_USERNAME -NonInteractive
# 4) Keep existing Steam page text (avoid overwriting title/description):
#    pwsh -File .\docs\upload_to_workshop.ps1 -Username YOUR_STEAM_USERNAME -KeepRemoteDescription -KeepRemoteTitle
# 5) Create a NEW Workshop item (ignores publishedfileid):
#    pwsh -File .\docs\upload_to_workshop.ps1 -Username YOUR_STEAM_USERNAME -CreateNew
#
# OPTIONAL ARGUMENTS:
# -WorkshopFile "C:\path\to\workshop.txt"  # Defaults to ..\QuickUseDrugs\workshop.txt relative to this script
# -SteamCmdPath  "C:\SteamCMD\steamcmd.exe" # Override SteamCMD path if installed elsewhere
# -KeepRemoteDescription                 # Do not upload local description; keep existing text on Workshop page
# -KeepRemoteTitle                       # Do not upload local title; keep existing title on Workshop page
#
# NOTES:
# - The script uploads everything under the folder pointed to by contentfolder in workshop.txt.
# - Your local paths in workshop.txt are NOT published; only files under contentfolder are uploaded.
# - Keep SteamCMD installed (default: C:\SteamCMD\steamcmd.exe). Install from steamcmd.zip if needed.
# - If Steam shows literal "\n" in the page, either edit the page once on Steam or run with -KeepRemoteDescription.
# =============================================

Param(
    [string]$Username,
    [string]$WorkshopFile,
    [string]$SteamCmdPath = "C:\SteamCMD\steamcmd.exe",
    [switch]$CreateNew,
    [switch]$NonInteractive,
    [switch]$KeepRemoteDescription,
    [switch]$KeepRemoteTitle
)

Write-Host "=== Project Zomboid Workshop Upload ===" -ForegroundColor Cyan

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Default workshop.txt path (repo/docs/ -> repo/QuickUseDrugs/workshop.txt)
if (-not $WorkshopFile -or $WorkshopFile.Trim() -eq "") {
    $WorkshopFile = Join-Path (Join-Path $ScriptDir "..\QuickUseDrugs") "workshop.txt"
}

if (-not (Test-Path -LiteralPath $SteamCmdPath)) {
    Write-Error "SteamCMD not found at: $SteamCmdPath"
    Write-Host "Install SteamCMD to C:\SteamCMD or pass -SteamCmdPath 'C:\path\to\steamcmd.exe'" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path -LiteralPath $WorkshopFile)) {
    Write-Error "workshop.txt not found at: $WorkshopFile"
    exit 1
}

# Optionally create a temp workshop file with modifications
$WorkshopToUse = $WorkshopFile
if ($CreateNew -or $KeepRemoteDescription -or $KeepRemoteTitle) {
    $tempDir = New-Item -ItemType Directory -Path ([System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "pz-workshop")) -Force
    $tempFile = Join-Path $tempDir ("workshop_" + [IO.Path]::GetFileName($WorkshopFile))
    $lines = Get-Content -LiteralPath $WorkshopFile -Raw
    $arr = $lines -split "\r?\n"
    if ($CreateNew) {
        $arr = $arr | Where-Object { $_ -notmatch '\"publishedfileid\"' }
    }
    if ($KeepRemoteDescription) {
        $arr = $arr | Where-Object { $_ -notmatch '^\s*\"description\"' }
    }
    if ($KeepRemoteTitle) {
        $arr = $arr | Where-Object { $_ -notmatch '^\s*\"title\"' }
    }
    $updated = ($arr -join "`r`n")
    Set-Content -LiteralPath $tempFile -Value $updated -NoNewline
    $WorkshopToUse = $tempFile
    Write-Host ("Using temp workshop file → {0}" -f $WorkshopToUse) -ForegroundColor Yellow
}

if (-not $Username) {
    $Username = Read-Host "Steam username"
}

function ConvertFrom-SecureStringToPlain([Security.SecureString]$Secure) {
    if (-not $Secure) { return $null }
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Secure)
    try { [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
}

$loginArg = "+login $Username"
if ($NonInteractive) {
    $pwdSecure = Read-Host "Steam password" -AsSecureString
    $pwdPlain = ConvertFrom-SecureStringToPlain $pwdSecure
    $guard = Read-Host "Steam Guard code (press Enter if not required)"
    if ([string]::IsNullOrWhiteSpace($pwdPlain)) {
        Write-Error "Password required for -NonInteractive mode"
        exit 1
    }
    if ([string]::IsNullOrWhiteSpace($guard)) {
        $loginArg = "+login $Username $pwdPlain"
    } else {
        $loginArg = "+login $Username $pwdPlain $guard"
    }
}

# Use repo/docs as force install dir to reduce intermittent issues
$forceDir = $ScriptDir

Write-Host "SteamCMD: $SteamCmdPath" -ForegroundColor DarkGray
Write-Host "Workshop: $WorkshopToUse" -ForegroundColor DarkGray

$argsList = @(
    "+force_install_dir $forceDir",
    $loginArg,
    "+workshop_build_item `"$WorkshopToUse`"",
    "+quit"
)

& "$SteamCmdPath" @argsList
$exitCode = $LASTEXITCODE

if ($exitCode -eq 0) {
    Write-Host "SUCCESS: Workshop upload completed." -ForegroundColor Green
    if ($CreateNew) {
        Write-Host "If this was your first upload, note the new publishedfileid assigned by Steam." -ForegroundColor Yellow
    }
} else {
    Write-Host "ERROR: Upload failed with exit code $exitCode" -ForegroundColor Red
    Write-Host "Common issues: bad credentials, Steam Guard, missing files referenced by workshop.txt, connectivity." -ForegroundColor Yellow
}


