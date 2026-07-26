#Requires -Version 5.1
<#
.SYNOPSIS
  One-shot Windows release: Flutter build → Inno Setup installer → output/windows.

.DESCRIPTION
  Run on a Windows machine with Flutter (Windows desktop) and Inno Setup 6 installed.

.PARAMETER SkipBuild
  Skip flutter build; package an existing Release folder only.

.PARAMETER Clean
  Delete build\windows before flutter build.

.PARAMETER OutputDir
  Override default output directory (relative to project root or absolute).

.PARAMETER SkipRedistDownload
  Do not download VC_redist.x64.exe; fail if it is missing.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File installer\windows\build_release.ps1

.EXAMPLE
  .\installer\windows\build_release.ps1 -Clean

.EXAMPLE
  .\installer\windows\build_release.ps1 -SkipBuild -OutputDir D:\releases
#>
[CmdletBinding()]
param(
    [switch]$SkipBuild,
    [switch]$Clean,
    [string]$OutputDir = '',
    [switch]$SkipRedistDownload
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# ---------------------------------------------------------------------------
# Resolve project root (installer\windows → repo root)
# ---------------------------------------------------------------------------
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = (Resolve-Path (Join-Path $ScriptDir '..\..')).Path

. (Join-Path $ScriptDir 'config.ps1')

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-Fail {
    param([string]$Message)
    Write-Host "ERROR: $Message" -ForegroundColor Red
}

function Get-PubspecVersion {
    param([string]$PubspecPath)
    if (-not (Test-Path $PubspecPath)) {
        throw "pubspec.yaml not found at $PubspecPath"
    }
    $line = Get-Content -Path $PubspecPath -Encoding UTF8 |
        Where-Object { $_ -match '^\s*version\s*:\s*' } |
        Select-Object -First 1
    if (-not $line) {
        throw "Could not find version: in pubspec.yaml"
    }
    # version: 1.0.0+1  →  1.0.0
    if ($line -match 'version\s*:\s*([0-9]+(?:\.[0-9]+){1,3})') {
        return $Matches[1]
    }
    throw "Unrecognized version format in pubspec.yaml: $line"
}

function Find-Iscc {
    if ($env:INNO_SETUP_PATH) {
        $candidate = $env:INNO_SETUP_PATH
        if (Test-Path $candidate) {
            if ((Get-Item $candidate).PSIsContainer) {
                $candidate = Join-Path $candidate 'ISCC.exe'
            }
            if (Test-Path $candidate) { return (Resolve-Path $candidate).Path }
        }
        throw "INNO_SETUP_PATH is set but ISCC.exe was not found: $env:INNO_SETUP_PATH"
    }

    $cmd = Get-Command ISCC.exe -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    $defaults = @(
        "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
        "${env:ProgramFiles}\Inno Setup 6\ISCC.exe",
        "${env:LocalAppData}\Programs\Inno Setup 6\ISCC.exe"
    )
    foreach ($path in $defaults) {
        if ($path -and (Test-Path $path)) { return $path }
    }
    return $null
}

function Get-DotEnvValue {
    param(
        [Parameter(Mandatory = $true)][string]$EnvFilePath,
        [Parameter(Mandatory = $true)][string]$Key
    )

    if (-not (Test-Path $EnvFilePath)) {
        return $null
    }

    foreach ($rawLine in Get-Content -Path $EnvFilePath -Encoding UTF8) {
        $line = $rawLine.Trim()
        if (-not $line -or $line.StartsWith('#')) {
            continue
        }

        $eqIndex = $line.IndexOf('=')
        if ($eqIndex -lt 1) {
            continue
        }

        $name = $line.Substring(0, $eqIndex).Trim()
        if ($name -ne $Key) {
            continue
        }

        $value = $line.Substring($eqIndex + 1).Trim()
        if (
            ($value.StartsWith('"') -and $value.EndsWith('"')) -or
            ($value.StartsWith("'") -and $value.EndsWith("'"))
        ) {
            if ($value.Length -ge 2) {
                $value = $value.Substring(1, $value.Length - 2)
            }
        }
        return $value
    }

    return $null
}

function Ensure-VcRedist {
    param(
        [string]$RedistPath,
        [string]$Url,
        [switch]$SkipDownload
    )
    if (Test-Path $RedistPath) {
        Write-Host "VC++ redistributable found: $RedistPath"
        return
    }

    if ($SkipDownload) {
        throw "Missing $RedistPath. Place VC_redist.x64.exe there or omit -SkipRedistDownload."
    }

    $dir = Split-Path -Parent $RedistPath
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    Write-Step "Downloading VC++ Redistributable from Microsoft"
    Write-Host "URL: $Url"
    try {
        # TLS 1.2+ for aka.ms
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $Url -OutFile $RedistPath -UseBasicParsing
    }
    catch {
        throw "Failed to download VC_redist.x64.exe. Download manually from $Url and place it at $RedistPath. $($_.Exception.Message)"
    }

    if (-not (Test-Path $RedistPath) -or ((Get-Item $RedistPath).Length -lt 1MB)) {
        throw "Downloaded redistributable looks invalid: $RedistPath"
    }
    Write-Host "Saved: $RedistPath ($([math]::Round((Get-Item $RedistPath).Length / 1MB, 1)) MB)"
}

# ---------------------------------------------------------------------------
# Preconditions
# ---------------------------------------------------------------------------
Write-Step "Project root: $ProjectRoot"
Set-Location $ProjectRoot

if ($env:OS -ne 'Windows_NT') {
    Write-Fail "This script must run on Windows (Flutter Windows + Inno Setup)."
    exit 1
}

$appVersion = Get-PubspecVersion (Join-Path $ProjectRoot 'pubspec.yaml')
Write-Host "Version from pubspec.yaml: $appVersion"

$flutterCmd = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutterCmd) {
    Write-Fail "flutter not found on PATH. Install Flutter and ensure 'flutter' is available."
    exit 1
}

$iscc = Find-Iscc
if (-not $iscc) {
    Write-Fail @"
Inno Setup 6 (ISCC.exe) not found.
Install from https://jrsoftware.org/isinfo.php
Or set INNO_SETUP_PATH to the Inno Setup 6 folder or to ISCC.exe.
"@
    exit 1
}
Write-Host "ISCC: $iscc"

$releaseDir = Join-Path $ProjectRoot $PathConfig.FlutterReleaseDir
$exePath = Join-Path $releaseDir $AppConfig.AppExeName
$redistPath = Join-Path $ProjectRoot (Join-Path $PathConfig.RedistDir $PathConfig.RedistFileName)
$issPath = Join-Path $ProjectRoot $PathConfig.IssFile

if (-not (Test-Path $issPath)) {
    throw "Inno script not found: $issPath"
}

$outDir = if ($OutputDir) {
    if ([System.IO.Path]::IsPathRooted($OutputDir)) { $OutputDir }
    else { Join-Path $ProjectRoot $OutputDir }
}
else {
    Join-Path $ProjectRoot $PathConfig.DefaultOutputDir
}

if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

# ---------------------------------------------------------------------------
# Flutter build
# ---------------------------------------------------------------------------
if (-not $SkipBuild) {
    if ($Clean) {
        Write-Step "Cleaning build\windows"
        $winBuild = Join-Path $ProjectRoot 'build\windows'
        if (Test-Path $winBuild) {
            Remove-Item -Recurse -Force $winBuild
        }
    }

    Write-Step "flutter pub get"
    & flutter pub get
    if ($LASTEXITCODE -ne 0) { throw "flutter pub get failed (exit $LASTEXITCODE)" }

    $envFile = Join-Path $ProjectRoot '.env'
    if (-not (Test-Path $envFile)) {
        throw "Missing .env at project root ($envFile). Release builds require URL_SUPABASE and SUPABASE_KEY."
    }

    $urlSupabase = Get-DotEnvValue -EnvFilePath $envFile -Key 'URL_SUPABASE'
    $supabaseKey = Get-DotEnvValue -EnvFilePath $envFile -Key 'SUPABASE_KEY'
    if ([string]::IsNullOrWhiteSpace($urlSupabase) -or [string]::IsNullOrWhiteSpace($supabaseKey)) {
        throw "Missing URL_SUPABASE or SUPABASE_KEY in .env. Both are required for release builds."
    }

    Write-Step "flutter build windows --release (with dart-define from .env)"
    Write-Host "Env: URL_SUPABASE and SUPABASE_KEY found in .env"
    & flutter build windows --release `
        "--dart-define=URL_SUPABASE=$urlSupabase" `
        "--dart-define=SUPABASE_KEY=$supabaseKey"
    if ($LASTEXITCODE -ne 0) { throw "flutter build windows failed (exit $LASTEXITCODE)" }
}
else {
    Write-Step "Skipping Flutter build (-SkipBuild)"
}

if (-not (Test-Path $exePath)) {
    throw "Release executable not found: $exePath. Run without -SkipBuild first."
}
Write-Host "Release EXE: $exePath"

# ---------------------------------------------------------------------------
# Runtime redistributable
# ---------------------------------------------------------------------------
Ensure-VcRedist -RedistPath $redistPath -Url $VcRedistUrl -SkipDownload:$SkipRedistDownload

# ---------------------------------------------------------------------------
# Compile installer
# ---------------------------------------------------------------------------
Write-Step "Compiling Inno Setup installer"

# ProjectRoot for ISS: path relative to the .iss file location (installer\windows)
# Use absolute paths via defines where possible for reliability.
$projectRootForIss = $ProjectRoot

# Quote each /D so values with spaces (and paths) stay one ISCC argument.
$defines = @(
    "/DMyAppName=`"$($AppConfig.AppName)`"",
    "/DMyAppVersion=`"$appVersion`"",
    "/DMyAppPublisher=`"$($AppConfig.AppPublisher)`"",
    "/DMyAppExeName=`"$($AppConfig.AppExeName)`"",
    "/DMyAppId=`"$($AppConfig.AppId)`"",
    "/DMyAppOutputBase=`"$($AppConfig.OutputBaseName)`"",
    "/DMyRegistryKey=`"$($AppConfig.RegistryKey)`"",
    "/DProjectRoot=`"$projectRootForIss`""
)

# /O overrides [Setup] OutputDir so OutputDir param and defaults stay aligned.
& $iscc @defines "/O$outDir" $issPath
if ($LASTEXITCODE -ne 0) {
    throw "ISCC failed (exit $LASTEXITCODE)"
}

$setupName = "$($AppConfig.OutputBaseName)-$appVersion.exe"
$setupPath = Join-Path $outDir $setupName

if (-not (Test-Path $setupPath)) {
    # Fallback: pick newest setup exe in output dir
    $newest = Get-ChildItem -Path $outDir -Filter '*.exe' -File |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
    if ($newest) {
        $setupPath = $newest.FullName
        $setupName = $newest.Name
    }
    else {
        throw "Installer EXE not found in $outDir after ISCC."
    }
}

Write-Step "Done"
Write-Host "Installer: $setupPath" -ForegroundColor Green

try {
    $hash = (Get-FileHash -Path $setupPath -Algorithm SHA256).Hash
    Write-Host "SHA256:   $hash"
}
catch {
    Write-Host "SHA256:   (could not compute)"
}

Write-Host ""
Write-Host "Ship the installer from: $outDir"
exit 0
