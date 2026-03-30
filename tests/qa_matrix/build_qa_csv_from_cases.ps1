param(
  [string]$CasesRoot = '08_EXAMPLES/BEFORE_AFTER',
  [string]$OutputCsv = 'tests/qa_matrix/qa_case_template.csv'
)

$ErrorActionPreference = 'Stop'

$caseDirs = Get-ChildItem -Path $CasesRoot -Directory | Sort-Object Name
if ($caseDirs.Count -eq 0) {
  throw "No case directories found under $CasesRoot"
}

function Get-MapValue {
  param(
    [hashtable]$Map,
    [string]$Key
  )
  if ($Map.ContainsKey($Key)) {
    return $Map[$Key]
  }
  return ''
}

$rows = @()
foreach ($dir in $caseDirs) {
  $caseId = $dir.Name
  $notesPath = Join-Path $dir.FullName 'case_notes.md'

  if (-not (Test-Path $notesPath)) {
    Write-Warning "Missing case_notes.md for $caseId. Skipping."
    continue
  }

  $lineMap = @{}
  $lines = Get-Content $notesPath

  foreach ($line in $lines) {
    $match = [regex]::Match($line, '^\s*-\s*([a-zA-Z0-9_]+)\s*:\s*(.*)$')
    if ($match.Success) {
      $key = $match.Groups[1].Value.Trim().ToLowerInvariant()
      $value = $match.Groups[2].Value.Trim()
      $lineMap[$key] = $value
    }
  }

  $rows += [PSCustomObject]@{
    case_id = $caseId
    product_type = (Get-MapValue -Map $lineMap -Key 'product_type')
    input_quality = (Get-MapValue -Map $lineMap -Key 'input_quality')
    input_long_edge_px = (Get-MapValue -Map $lineMap -Key 'input_long_edge_px')
    preset_tier = (Get-MapValue -Map $lineMap -Key 'preset_tier')
    recipe = (Get-MapValue -Map $lineMap -Key 'recipe')
    classification = (Get-MapValue -Map $lineMap -Key 'classification')
    blocker_defect = (Get-MapValue -Map $lineMap -Key 'blocker_defect')
    tolerable_defect = (Get-MapValue -Map $lineMap -Key 'tolerable_defect')
    runtime_seconds = (Get-MapValue -Map $lineMap -Key 'runtime_seconds')
    reviewer = (Get-MapValue -Map $lineMap -Key 'reviewer')
    notes = (Get-MapValue -Map $lineMap -Key 'notes')
  }
}

$rows | Export-Csv -Path $OutputCsv -NoTypeInformation -Encoding UTF8
Write-Host "Wrote QA CSV: $OutputCsv"
