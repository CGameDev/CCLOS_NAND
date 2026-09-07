param([string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path)
$ErrorActionPreference = 'Stop'
$registryPath = Join-Path $Root 'docs\ui\CCLOS_NAND_ExactUI\03_SCREEN_REGISTRY.json'
if (!(Test-Path -LiteralPath $registryPath)) { throw "Missing registry: $registryPath" }
$registry = Get-Content -LiteralPath $registryPath -Raw | ConvertFrom-Json
$failed = $false
foreach ($s in $registry.screens) {
    $p = Join-Path $Root ($s.path -replace '/', [IO.Path]::DirectorySeparatorChar)
    if (!(Test-Path -LiteralPath $p)) { Write-Host "MISSING  $($s.path)" -ForegroundColor Red; $failed=$true; continue }
    $h = (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
    if ($h -ne $s.sha256.ToLowerInvariant()) { Write-Host "MISMATCH $($s.path)" -ForegroundColor Red; $failed=$true }
    else { Write-Host "OK       $($s.path)" -ForegroundColor Green }
}
if ($failed) { throw 'CCLOS ExactUI binary reference validation failed. Do not begin visual implementation.' }
Write-Host 'All authoritative CCLOS ExactUI screen hashes validated.' -ForegroundColor Green
