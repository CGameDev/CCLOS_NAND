<#
.SYNOPSIS
    Freezes/imports the owner-approved local CCLOS source into src/CCLOS
    without modifying the donor workspace.

.DESCRIPTION
    The CCLOS NAND Edition baseline donor is the latest validated local CCLOS
    workspace at C:\cctu. The donor may contain owner-approved uncommitted
    fixes. This script records Git/worktree identity, copies the approved local
    source state into src/CCLOS while excluding clearly transient/non-source
    material, and generates a deterministic SHA-256 source/resource manifest.

    The donor is READ ONLY by policy. This script performs no Git mutation and
    no NAND work.
#>

[CmdletBinding()]
param(
    [string]$SourcePath = 'C:\cctu',
    [string]$ExpectedVersion = '0.35.4',
    [string]$Destination = (Join-Path $PSScriptRoot '..\src\CCLOS'),
    [string]$FreezeMetadataPath = (Join-Path $PSScriptRoot '..\baseline\_resolver\local-baseline-freeze.json')
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

$actualVersion = $versionMatch.Groups[1].Value
$buildLabel = if ($labelMatch.Success) { $labelMatch.Groups[1].Value } else { $null }

if ($ExpectedVersion -and $actualVersion -ne $ExpectedVersion) {
    Fail ("Local donor reports CCLOS {0}, expected owner-approved baseline {1}. Update the baseline contract before importing a different version." -f $actualVersion, $ExpectedVersion)
}

if (Test-Path -LiteralPath $Destination) {
    Fail ("Destination already exists: {0}. Do not overwrite a frozen baseline. Remove/rename it only after confirming no baseline work will be lost." -f $Destination)
}

# Capture Git identity without mutating the donor.
$insideResult = Invoke-GitReadOnly -Repo $resolvedSource -Arguments @('rev-parse','--is-inside-work-tree') -AllowFailure
$isGitWorktree = ($insideResult.ExitCode -eq 0 -and (($insideResult.Output -join '').Trim() -eq 'true'))
$headSha = $null
$branch = $null
$statusLines = @()
$isDirty = $null
$gitTopLevel = $null
$gitDir = $null

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

$changedPaths = @()
foreach ($line in $statusLines) {
    if ($line.Length -ge 4) {
        $changedPaths += [pscustomobject]@{
            status = $line.Substring(0,2)
            path   = $line.Substring(3)
        }
    }
}

$destinationParent = Split-Path -Parent $Destination
if (-not (Test-Path -LiteralPath $destinationParent)) {
    New-Item -ItemType Directory -Path $destinationParent -Force | Out-Null
}
New-Item -ItemType Directory -Path $Destination -Force | Out-Null

# Clearly transient/non-source directories. If a future build proves one is
# required, update this reviewed list rather than silently copying everything.
$excludeDirs = @(
    '.git',
    '.tmp',
    '.deployment-backups',
    '.packaging-watchlist-v1',
    '.packaging-watchlist-v1-hotfix1',
    '.packaging-watchlist-v1-hotfix2',
    '.vs',
    'Debug',
    'Release',
    'Release_LTCG',
    'Profile',
    'Profile_FastCap',
    'ipch',
    'Releases'
)

$excludeFiles = @(
    '*.sdf',
    '*.suo',
    '*.user',
    '*.opensdf',
    '*.pdb',
    '*.obj',
    '*.ilk',
    '*.tlog',
    '*.lastbuildstate'
)

Write-Host 'Freezing owner-approved CCLOS local source...' -ForegroundColor Cyan
Write-Host ("Source:      {0}" -f $resolvedSource)
Write-Host ("Destination: {0}" -f $Destination)
Write-Host ("Version:     {0}" -f $actualVersion)
Write-Host ("Build label: {0}" -f $buildLabel)
Write-Host ("HEAD:        {0}" -f $headSha)
Write-Host ("Dirty:       {0}" -f $isDirty)
Write-Host ''

$roboArgs = @(
    $resolvedSource,
    $Destination,
    '/E',
    '/COPY:DAT',
    '/DCOPY:DAT',
    '/R:1',
    '/W:1',
    '/NFL',
    '/NDL',
    '/NJH',
    '/NJS',
    '/NP'
)

if ($excludeDirs.Count -gt 0) {
    $roboArgs += '/XD'
    $roboArgs += $excludeDirs
}

if ($excludeFiles.Count -gt 0) {
    $roboArgs += '/XF'
    $roboArgs += $excludeFiles
}

& robocopy @roboArgs | Out-Null
$roboCode = $LASTEXITCODE

# Robocopy exit codes 0-7 are successful/nonfatal states.
if ($roboCode -gt 7) {
    Remove-Item -LiteralPath $Destination -Recurse -Force -ErrorAction SilentlyContinue
    Fail ("Baseline copy failed with robocopy exit code {0}." -f $roboCode)
}

$manifestPath = Join-Path $destinationParent 'CCLOS-baseline-manifest.sha256'
$files = Get-ChildItem -LiteralPath $Destination -File -Recurse | Sort-Object FullName
$root = (Resolve-Path -LiteralPath $Destination).Path

$lines = foreach ($file in $files) {
    $hash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
    $relative = $file.FullName.Substring($root.Length).TrimStart('\')
    "{0}  {1}" -f $hash, $relative.Replace('\','/')
}

[IO.File]::WriteAllLines($manifestPath, $lines, [Text.UTF8Encoding]::new($false))
$manifestHash = (Get-FileHash -LiteralPath $manifestPath -Algorithm SHA256).Hash.ToLowerInvariant()

$freezeDir = Split-Path -Parent $FreezeMetadataPath
if (-not (Test-Path -LiteralPath $freezeDir)) {
    New-Item -ItemType Directory -Path $freezeDir -Force | Out-Null
}

$freeze = [ordered]@{
    schemaVersion       = 1
    frozenUtc           = [DateTime]::UtcNow.ToString('o')
    sourcePath          = $resolvedSource
    destination         = (Resolve-Path -LiteralPath $Destination).Path
    version             = $actualVersion
    buildLabel          = $buildLabel
    manifestPath        = (Resolve-Path -LiteralPath $manifestPath).Path
    manifestSha256      = $manifestHash
    importedFileCount   = $files.Count
    git = [ordered]@{
        isWorktree       = $isGitWorktree
        topLevel         = $gitTopLevel
        gitDir           = $gitDir
        headSha          = $headSha
        branch           = $branch
        workingTreeDirty = $isDirty
        changedPaths     = $changedPaths
    }
    exclusions = [ordered]@{
        directories = $excludeDirs
        filePatterns = $excludeFiles
        policy = 'Transient/non-source exclusions only; review if build validation proves a dependency.'
    }
    donorMutationPerformed = $false
}

$freeze | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $FreezeMetadataPath -Encoding UTF8

Write-Host ''
Write-Host 'CCLOS baseline frozen/imported without modifying the donor.' -ForegroundColor Green
Write-Host ("Version:        {0}" -f $actualVersion)
Write-Host ("Build label:    {0}" -f $buildLabel)
Write-Host ("HEAD:           {0}" -f $headSha)
Write-Host ("Working dirty:  {0}" -f $isDirty)
Write-Host ("Files imported: {0}" -f $files.Count)
Write-Host ("Destination:    {0}" -f (Resolve-Path -LiteralPath $Destination).Path)
Write-Host ("Manifest:       {0}" -f (Resolve-Path -LiteralPath $manifestPath).Path)
Write-Host ("Manifest SHA:   {0}" -f $manifestHash)
Write-Host ("Freeze record:  {0}" -f (Resolve-Path -LiteralPath $FreezeMetadataPath).Path)
Write-Host ''
Write-Host 'NEXT: build the frozen baseline unchanged, create docs/BASELINE_FREEZE_REPORT.md, then update baseline/baseline.lock.json resolved fields.'
