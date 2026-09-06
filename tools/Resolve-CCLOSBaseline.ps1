<#
.SYNOPSIS
    Audits the owner-approved local CCLOS donor workspace without modifying it.

.DESCRIPTION
    CCLOS NAND Edition uses the latest validated local CCLOS source at
    C:\cctu as its owner-approved baseline donor. This script performs a
    read-only audit of that workspace and records Git/worktree identity,
    version/build label, and sanitized changed/untracked paths.

    The script DOES NOT reset, clean, checkout, stash, rebase, commit, copy,
    or otherwise mutate the donor workspace. It performs no NAND work.
#>

[CmdletBinding()]
param(
    [string]$SourcePath = 'C:\cctu',
    [string]$ExpectedVersion = '0.35.4',
    [string]$OutputPath = (Join-Path $PSScriptRoot '..\baseline\_resolver\local-baseline-audit.json')
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Fail([string]$Message) {
    Write-Error $Message
    exit 1
}

function Invoke-GitReadOnly {
    param(
        [Parameter(Mandatory=$true)][string]$Repo,
        [Parameter(Mandatory=$true)][string[]]$Arguments,
        [switch]$AllowFailure
    )

    $output = & git -C $Repo @Arguments 2>$null
    $code = $LASTEXITCODE

    if ($code -ne 0 -and -not $AllowFailure) {
        Fail ("git {0} failed in {1}." -f ($Arguments -join ' '), $Repo)
    }

    return [pscustomobject]@{
        ExitCode = $code
        Output   = @($output)
    }
}

if (-not (Test-Path -LiteralPath $SourcePath -PathType Container)) {
    Fail ("Local CCLOS donor path does not exist: {0}" -f $SourcePath)
}

$resolvedSource = (Resolve-Path -LiteralPath $SourcePath).Path
$versionFile = Join-Path $resolvedSource 'ConsoleCrateNativeStore\ConsoleCrateVersion.h'

if (-not (Test-Path -LiteralPath $versionFile -PathType Leaf)) {
    Fail ("CCLOS version file was not found: {0}" -f $versionFile)
}

$versionText = Get-Content -LiteralPath $versionFile -Raw
$versionMatch = [regex]::Match($versionText, '#define\s+CONSOLECRATE_VERSION\s+"([^"]+)"')
$labelMatch = [regex]::Match($versionText, '#define\s+CONSOLECRATE_VERSION_LABEL\s+"([^"]+)"')

if (-not $versionMatch.Success) {
    Fail 'Unable to parse CONSOLECRATE_VERSION from the local donor.'
}

$version = $versionMatch.Groups[1].Value
$buildLabel = if ($labelMatch.Success) { $labelMatch.Groups[1].Value } else { $null }

if ($ExpectedVersion -and $version -ne $ExpectedVersion) {
    Fail ("Local donor reports CCLOS {0}; baseline contract currently expects {1}. Update the owner-approved baseline contract before importing a different version." -f $version, $ExpectedVersion)
}

$insideResult = Invoke-GitReadOnly -Repo $resolvedSource -Arguments @('rev-parse','--is-inside-work-tree') -AllowFailure
$isGitWorktree = ($insideResult.ExitCode -eq 0 -and (($insideResult.Output -join '').Trim() -eq 'true'))

$gitTopLevel = $null
$gitDir = $null
$headSha = $null
$branch = $null
$statusLines = @()
$isDirty = $null

if ($isGitWorktree) {
    $gitTopLevel = ((Invoke-GitReadOnly -Repo $resolvedSource -Arguments @('rev-parse','--show-toplevel')).Output -join "`n").Trim()
    $gitDir = ((Invoke-GitReadOnly -Repo $resolvedSource -Arguments @('rev-parse','--git-dir')).Output -join "`n").Trim()
    $headSha = ((Invoke-GitReadOnly -Repo $resolvedSource -Arguments @('rev-parse','HEAD')).Output -join "`n").Trim()

    $branchResult = Invoke-GitReadOnly -Repo $resolvedSource -Arguments @('branch','--show-current') -AllowFailure
    $branch = (($branchResult.Output -join "`n").Trim())
    if ([string]::IsNullOrWhiteSpace($branch)) { $branch = $null }

    $statusResult = Invoke-GitReadOnly -Repo $resolvedSource -Arguments @('status','--porcelain=v1','--untracked-files=all')
    $statusLines = @($statusResult.Output | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    $isDirty = ($statusLines.Count -gt 0)
}

# Keep only Git porcelain status + relative paths. Do not read or expose file contents.
$changedPaths = @()
foreach ($line in $statusLines) {
    if ($line.Length -ge 4) {
        $statusCode = $line.Substring(0,2)
        $relativePath = $line.Substring(3)
        $changedPaths += [pscustomobject]@{
            status = $statusCode
            path   = $relativePath
        }
    }
}

$audit = [ordered]@{
    schemaVersion       = 1
    auditedUtc          = [DateTime]::UtcNow.ToString('o')
    sourcePath          = $resolvedSource
    sourceIsReadOnlyDonorByPolicy = $true
    version             = $version
    buildLabel          = $buildLabel
    expectedVersion     = $ExpectedVersion
    git = [ordered]@{
        isWorktree       = $isGitWorktree
        topLevel         = $gitTopLevel
        gitDir           = $gitDir
        headSha          = $headSha
        branch           = $branch
        workingTreeDirty = $isDirty
        changedPaths     = $changedPaths
    }
    ownerPolicy = [ordered]@{
        latestLocalSourceAuthorized = $true
        exactV0352ProvenanceRequired = $false
        donorMutationAllowed = $false
    }
}

$outputDir = Split-Path -Parent $OutputPath
if (-not (Test-Path -LiteralPath $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

$audit | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutputPath -Encoding UTF8

Write-Host ''
Write-Host 'Owner-approved CCLOS local donor audit complete.' -ForegroundColor Green
Write-Host ("Source:       {0}" -f $resolvedSource)
Write-Host ("Version:      {0}" -f $version)
Write-Host ("Build label:  {0}" -f $buildLabel)
Write-Host ("Git worktree: {0}" -f $isGitWorktree)
Write-Host ("HEAD:         {0}" -f $headSha)
Write-Host ("Branch:       {0}" -f $branch)
Write-Host ("Dirty:        {0}" -f $isDirty)
Write-Host ("Audit file:   {0}" -f (Resolve-Path -LiteralPath $OutputPath).Path)
Write-Host ''

if ($changedPaths.Count -gt 0) {
    Write-Host 'Sanitized changed/untracked paths:' -ForegroundColor Yellow
    $changedPaths | Format-Table -AutoSize
    Write-Host ''
}

Write-Host 'No donor files were modified.' -ForegroundColor Green
Write-Host 'NEXT: freeze/import the exact approved local state with Import-CCLOSBaseline.ps1.'
