param(
  [string]$Version = 'v1-beta',
  [string]$OutputDir = 'release'
)

$ErrorActionPreference = 'Stop'

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$zipName = "Catalog-Clean-Up-Kit-$Version-$timestamp.zip"
$zipPath = Join-Path $OutputDir $zipName

$include = @(
  '00_START_HERE',
  '01_WORKFLOWS',
  '02_PRESETS',
  '03_RECIPES_AND_PROMPTS',
  '04_DEPENDENCIES',
  '05_INSTALLATION',
  '06_TROUBLESHOOTING',
  '07_QA',
  '08_EXAMPLES',
  '09_EXPORT',
  '10_COMMERCIAL',
  'LICENSE',
  'README.md',
  'CHANGELOG.md',
  'scope_freeze.md',
  'buyer_and_promise.md',
  'v1_in_scope_out_of_scope.md',
  'architecture_functional_map.md'
)

$staging = Join-Path $OutputDir 'build'
if (Test-Path $staging) {
  Remove-Item -Recurse -Force $staging
}
New-Item -ItemType Directory -Path $staging | Out-Null

foreach ($item in $include) {
  if (-not (Test-Path $item)) {
    throw "Cannot package: missing '$item'"
  }

  if (Test-Path $item -PathType Container) {
    Copy-Item -Path $item -Destination (Join-Path $staging $item) -Recurse -Force
  }
  else {
    $destDir = Split-Path -Parent (Join-Path $staging $item)
    if ($destDir -and -not (Test-Path $destDir)) {
      New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    Copy-Item -Path $item -Destination (Join-Path $staging $item) -Force
  }
}

if (Test-Path $zipPath) {
  Remove-Item -Force $zipPath
}

Compress-Archive -Path (Join-Path $staging '*') -DestinationPath $zipPath
Write-Host "Beta package created: $zipPath"
