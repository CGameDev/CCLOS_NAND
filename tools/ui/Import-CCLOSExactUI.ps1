param(
  [Parameter(Mandatory=$true)][string]$PackageZip,
  [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
)
$ErrorActionPreference = 'Stop'
$expectedZipHash = '56037f4dea206c12304891fa33092aa79a2479a7749b26d091487035bd9be08c'
$actualZipHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $PackageZip).Hash.ToLowerInvariant()
if ($actualZipHash -ne $expectedZipHash) { throw "Package hash mismatch. Expected $expectedZipHash; got $actualZipHash" }
$temp = Join-Path $env:TEMP ('CCLOS_ExactUI_' + [guid]::NewGuid().ToString('N'))
Expand-Archive -LiteralPath $PackageZip -DestinationPath $temp -Force
$packageRoot = Join-Path $temp 'CCLOS_NAND_ExactUI_v1.0'
if (!(Test-Path $packageRoot)) { throw 'Expected package root not found after extraction.' }
$designDest = Join-Path $RepoRoot 'design\CCLOS_NAND_ExactUI'
New-Item -ItemType Directory -Force -Path $designDest | Out-Null
foreach ($dir in @('01_global_shell','02_shared_components','03_main_screens','04_submenus','05_supplemental')) {
    Copy-Item -LiteralPath (Join-Path $packageRoot $dir) -Destination $designDest -Recurse -Force
}
& (Join-Path $RepoRoot 'tools\ui\Validate-CCLOSExactUI.ps1') -Root $RepoRoot
Write-Host 'ExactUI assets imported and verified locally. Review git status before committing.' -ForegroundColor Green
