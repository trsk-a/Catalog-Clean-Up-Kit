$ErrorActionPreference = 'Stop'

$targetFiles = @(
  '04_DEPENDENCIES/COMPATIBILITY_MATRIX.md',
  '04_DEPENDENCIES/COMFYUI_VERSION.txt',
  '04_DEPENDENCIES/CUSTOM_NODES_LOCKFILE.md',
  '04_DEPENDENCIES/MODELS_REQUIRED.md'
)

$pattern = 'PIN_ME'
$hits = @()

foreach ($file in $targetFiles) {
  if (-not (Test-Path $file)) {
    throw "Missing dependency file: $file"
  }

  $matches = Select-String -Path $file -Pattern $pattern
  foreach ($match in $matches) {
    $hits += "${file}:$($match.LineNumber)"
  }
}

if ($hits.Count -gt 0) {
  throw ("Found unresolved placeholders:`n" + ($hits -join "`n"))
}

Write-Host 'No dependency placeholders found.'
