$ErrorActionPreference = 'Stop'

$file = '01_WORKFLOWS/V1_EXPORT_VALIDATION/ccuk_v1_export_validation.json'
if (-not (Test-Path $file)) {
  throw "Missing export validation workflow: $file"
}

$json = Get-Content $file -Raw | ConvertFrom-Json
if (-not $json.exports) {
  throw 'Missing exports array in export validation workflow.'
}

$ratios = $json.exports | ForEach-Object { $_.ratio }
$requiredRatios = @('1:1', '4:5', '9:16')

foreach ($ratio in $requiredRatios) {
  if (-not ($ratios -contains $ratio)) {
    throw "Missing export ratio '$ratio' in export validation workflow."
  }
}

Write-Host 'Export validation smoke test passed.'
