param(
  [Parameter(Mandatory=$true)][string]$PackageZip,
  [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path,
  [string]$CommitMessage = 'design: import owner-approved CCLOS NAND ExactUI binary references'
)
$ErrorActionPreference = 'Stop'

& (Join-Path $PSScriptRoot 'Import-CCLOSExactUI.ps1') -PackageZip $PackageZip -RepoRoot $RepoRoot

$expectedBranch = 'main'
$currentBranch = (git -C $RepoRoot rev-parse --abbrev-ref HEAD).Trim()
if ($LASTEXITCODE -ne 0) { throw 'Unable to determine git branch.' }
if ($currentBranch -ne $expectedBranch) { throw "Expected branch '$expectedBranch'; found '$currentBranch'. No publish attempted." }

$porcelain = git -C $RepoRoot status --porcelain -- design/CCLOS_NAND_ExactUI docs/ui/CCLOS_NAND_ExactUI tools/ui
if ($LASTEXITCODE -ne 0) { throw 'git status failed.' }
if ([string]::IsNullOrWhiteSpace(($porcelain -join "`n"))) {
  Write-Host 'No ExactUI changes to publish.' -ForegroundColor Yellow
  exit 0
}

git -C $RepoRoot add -- design/CCLOS_NAND_ExactUI docs/ui/CCLOS_NAND_ExactUI tools/ui
if ($LASTEXITCODE -ne 0) { throw 'git add failed.' }
git -C $RepoRoot commit -m $CommitMessage
if ($LASTEXITCODE -ne 0) { throw 'git commit failed.' }
git -C $RepoRoot push origin $expectedBranch
if ($LASTEXITCODE -ne 0) { throw 'git push failed. No force push was attempted.' }
Write-Host 'ExactUI binary references committed and pushed.' -ForegroundColor Green
