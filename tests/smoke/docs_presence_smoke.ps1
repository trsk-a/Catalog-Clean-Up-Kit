$ErrorActionPreference = 'Stop'

$requiredDocs = @(
  'README.md',
  'scope_freeze.md',
  'buyer_and_promise.md',
  'v1_in_scope_out_of_scope.md',
  'architecture_functional_map.md',
  '04_DEPENDENCIES/COMPATIBILITY_MATRIX.md',
  '05_INSTALLATION/CLEAN_INSTALL_WINDOWS.md',
  '05_INSTALLATION/CLEAN_INSTALL_LINUX.md',
  '06_TROUBLESHOOTING/TROUBLESHOOTING_MASTER.md',
  '07_QA/QA_MATRIX.md',
  '09_EXPORT/OUTPUT_READY_CHECKLIST.md',
  '10_COMMERCIAL/OFFER_STRUCTURE.md'
)

$missing = @()
foreach ($doc in $requiredDocs) {
  if (-not (Test-Path $doc)) {
    $missing += $doc
  }
}

if ($missing.Count -gt 0) {
  throw ("Missing required docs: " + ($missing -join ', '))
}

Write-Host 'Docs presence smoke test passed.'
