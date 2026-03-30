$ErrorActionPreference = 'Stop'

$workflowFiles = @(
  '01_WORKFLOWS/V1_MAIN/ccuk_v1_main_core.json',
  '01_WORKFLOWS/V1_MAIN/ccuk_v1_main_annotated.json',
  '01_WORKFLOWS/V1_NEUTRAL_BG/ccuk_v1_neutral_bg_core.json',
  '01_WORKFLOWS/V1_EXPORT_VALIDATION/ccuk_v1_export_validation.json'
)

foreach ($file in $workflowFiles) {
  if (-not (Test-Path $file)) {
    throw "Missing workflow file: $file"
  }

  try {
    Get-Content $file -Raw | ConvertFrom-Json | Out-Null
  }
  catch {
    throw "Invalid JSON in $file"
  }
}

Write-Host "Workflow JSON smoke test passed."
