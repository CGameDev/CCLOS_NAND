<#
.SYNOPSIS
    Imports an explicitly resolved CCLOS public-release source commit into
    src/CCLOS without changing source files.

.DESCRIPTION
    This script requires an immutable commit SHA and validates that the donor
    source reports ExpectedVersion before copying. It intentionally refuses
    branch names and floating refs as the final baseline identity.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidatePattern('^[0-9a-fA-F]{40}$')]
    [string]$CommitSha,

    [string]$Repository = 'https://github.com/CGameDev/ConsoleCrateLive.git',
    [string]$ExpectedVersion = '0.35.2',
    [string]$Destination = (Join-Path $PSScriptRoot '..\src\CCLOS')
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Fail([string]$Message) {
    Write-Error $Message
    exit 1
}

$workRoot = Join-Path $env:TEMP ('CCLOS-NAND-Baseline-' + [guid]::NewGuid().ToString('N'))
$repoPath = Join-Path $workRoot 'donor'
$versionPath = 'ConsoleCrateNativeStore/ConsoleCrateVersion.h'

New-Item -ItemType Directory -Path $workRoot -Force | Out-Null

try {
    git clone --filter=blob:none --no-checkout $Repository $repoPath
    if ($LASTEXITCODE -ne 0) { Fail 'Unable to clone CCLOS donor repository.' }

    Push-Location $repoPath
    try {
        git fetch origin $CommitSha
        if ($LASTEXITCODE -ne 0) { Fail 'Requested baseline commit cannot be fetched.' }

        $resolved = (git rev-parse $CommitSha).Trim()
        if ($resolved -ne $CommitSha.ToLowerInvariant()) {
            Fail 'Resolved commit identity differs from requested immutable SHA.'
        }

        $versionText = git show ("{0}:{1}" -f $CommitSha, $versionPath)
        if ($LASTEXITCODE -ne 0 -or -not $versionText) {
            Fail 'Baseline version file is missing from the requested commit.'
        }

        $joined = ($versionText -join "`n")
        $match = [regex]::Match($joined, '#define\s+CONSOLECRATE_VERSION\s+"([^"]+)"')
        if (-not $match.Success) { Fail 'Unable to parse CONSOLECRATE_VERSION.' }
        $actualVersion = $match.Groups[1].Value

        if ($actualVersion -ne $ExpectedVersion) {
            Fail ("Requested commit reports CCLOS {0}, expected {1}. Import refused." -f $actualVersion, $ExpectedVersion)
        }

        git checkout --detach $CommitSha
        if ($LASTEXITCODE -ne 0) { Fail 'Unable to check out resolved baseline commit.' }
    }
    finally {
        Pop-Location
    }

    if (Test-Path $Destination) {
        Fail ("Destination already exists: {0}. Delete it only after confirming no baseline work will be lost." -f $Destination)
    }

    New-Item -ItemType Directory -Path $Destination -Force | Out-Null

    # Copy the donor working tree exactly while excluding Git metadata only.
    # Cleanup/bloat reduction is a later reviewed milestone; baseline import
    # must remain provenance-faithful.
    Get-ChildItem -LiteralPath $repoPath -Force | Where-Object { $_.Name -ne '.git' } | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $Destination -Recurse -Force
    }

    $manifestPath = Join-Path (Split-Path $Destination -Parent) 'CCLOS-baseline-manifest.sha256'
    $files = Get-ChildItem -LiteralPath $Destination -File -Recurse | Sort-Object FullName
    $root = (Resolve-Path $Destination).Path
    $lines = foreach ($file in $files) {
        $hash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
        $relative = $file.FullName.Substring($root.Length).TrimStart('\')
        "{0}  {1}" -f $hash, $relative.Replace('\','/')
    }
    [IO.File]::WriteAllLines($manifestPath, $lines, [Text.UTF8Encoding]::new($false))

    $manifestHash = (Get-FileHash -LiteralPath $manifestPath -Algorithm SHA256).Hash.ToLowerInvariant()

    Write-Host ''
    Write-Host 'CCLOS baseline imported without source modification.' -ForegroundColor Green
    Write-Host ("Version:       {0}" -f $actualVersion)
    Write-Host ("Commit:        {0}" -f $CommitSha)
    Write-Host ("Destination:   {0}" -f (Resolve-Path $Destination).Path)
    Write-Host ("Manifest:      {0}" -f $manifestPath)
    Write-Host ("Manifest SHA:  {0}" -f $manifestHash)
    Write-Host ''
    Write-Host 'Update baseline/baseline.lock.json only after public-artifact provenance is also verified.'
}
finally {
    if (Test-Path $workRoot) {
        Remove-Item -LiteralPath $workRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}
