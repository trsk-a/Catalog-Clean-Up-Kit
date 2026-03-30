$ErrorActionPreference = 'Stop'

$tests = @(
  'tests/smoke/workflow_json_smoke.ps1',
  'tests/smoke/preset_json_smoke.ps1',
  'tests/smoke/docs_presence_smoke.ps1',
  'tests/smoke/export_validation_smoke.ps1'
)

foreach ($test in $tests) {
  Write-Host "Running $test"
  & $test
}

Write-Host 'All smoke tests passed.'
