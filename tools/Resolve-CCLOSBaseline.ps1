<#
.SYNOPSIS
    Resolves the exact ConsoleCrate Live source ref that reports the required
    public-release version before any CCLOS NAND implementation is allowed.

.DESCRIPTION
    This script intentionally fails closed. It does not assume that the CCLOS
    branch is equivalent to the public beta. It clones/fetches the donor
    repository, inspects every local remote branch and tag that contains the
    canonical ConsoleCrateVersion.h path, and reports refs whose version equals
    ExpectedVersion.

    It makes no source changes and performs no NAND work.
#>

[CmdletBinding()]
param(
    [string]$Repository = 'https://github.com/CGameDev/ConsoleCrateLive.git',
    [string]$ExpectedVersion = '0.35.2',
    [string]$WorkRoot = (Join-Path $PSScriptRoot '..\baseline\_resolver')
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Fail([string]$Message) {
    Write-Error $Message
    exit 1
}

$repoPath = Join-Path $WorkRoot 'ConsoleCrateLive'
$versionPath = 'ConsoleCrateNativeStore/ConsoleCrateVersion.h'

if (Test-Path $WorkRoot) {
    Remove-Item -LiteralPath $WorkRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $WorkRoot -Force | Out-Null

Write-Host "Cloning donor repository for baseline provenance only..."
git clone --filter=blob:none --no-checkout $Repository $repoPath
if ($LASTEXITCODE -ne 0) { Fail 'git clone failed.' }

Push-Location $repoPath
try {
    git fetch --all --tags --prune
    if ($LASTEXITCODE -ne 0) { Fail 'git fetch failed.' }

    $refs = @()
    $refs += git for-each-ref --format='%(refname)' refs/remotes/origin
    $refs += git for-each-ref --format='%(refname)' refs/tags
    $refs = $refs | Where-Object { $_ -and $_ -notmatch '/HEAD$' } | Sort-Object -Unique

    $matches = @()
    foreach ($ref in $refs) {
        $content = git show ("{0}:{1}" -f $ref, $versionPath) 2>$null
        if ($LASTEXITCODE -ne 0 -or -not $content) { continue }

        $joined = ($content -join "`n")
        $m = [regex]::Match($joined, '#define\s+CONSOLECRATE_VERSION\s+"([^"]+)"')
        if (-not $m.Success) { continue }

        $version = $m.Groups[1].Value
        $sha = (git rev-parse $ref).Trim()
        Write-Host ("{0} -> {1} ({2})" -f $ref, $version, $sha)

        if ($version -eq $ExpectedVersion) {
            $matches += [pscustomobject]@{
                Ref = $ref
                CommitSha = $sha
                Version = $version
            }
        }
    }

    if ($matches.Count -eq 0) {
        Fail ("No donor ref reports CCLOS version {0}. Do NOT import another version or reconstruct the missing release. Obtain/publish the exact public-release source first." -f $ExpectedVersion)
    }

    if ($matches.Count -gt 1) {
        Write-Host 'Multiple matching refs were found:'
        $matches | Format-Table -AutoSize
        Fail 'Baseline provenance is ambiguous. Select the exact release-producing commit with owner evidence before import.'
    }

    Write-Host ''
    Write-Host 'Resolved baseline candidate:' -ForegroundColor Green
    $matches[0] | Format-List
    Write-Host ''
    Write-Host 'NEXT: verify this commit produced CCLOS_Public_Beta_v0.35.2.zip, then record it in baseline/baseline.lock.json.'
}
finally {
    Pop-Location
}
