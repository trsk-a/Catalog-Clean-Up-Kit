param(
  [string]$CsvPath = 'tests/qa_matrix/qa_case_template.csv'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $CsvPath)) {
  throw "QA CSV not found: $CsvPath"
}

$rows = Import-Csv -Path $CsvPath
if ($rows.Count -lt 10) {
  throw "Expected at least 10 rows, found $($rows.Count)"
}

$approved = ($rows | Where-Object { $_.classification -eq 'approved' }).Count
$usable = ($rows | Where-Object { $_.classification -eq 'usable_with_revision' }).Count
$outscope = ($rows | Where-Object { $_.classification -eq 'out_of_scope' }).Count
$blockers = ($rows | Where-Object { -not [string]::IsNullOrWhiteSpace($_.blocker_defect) }).Count

Write-Host "Total cases: $($rows.Count)"
Write-Host "Approved: $approved"
Write-Host "Usable with revision: $usable"
Write-Host "Out of scope: $outscope"
Write-Host "Rows with blocker defects: $blockers"

if ($approved -ge 7 -and $blockers -eq 0) {
  Write-Host 'QA gate: PASS (provisional)'
}
else {
  Write-Host 'QA gate: FAIL (needs iteration)'
  exit 2
}
