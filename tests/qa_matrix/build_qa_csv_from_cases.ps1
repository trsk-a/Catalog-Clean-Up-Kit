param(
  [string]$CasesRoot = '08_EXAMPLES/BEFORE_AFTER',
  [string]$OutputCsv = 'tests/qa_matrix/qa_case_template.csv'
)

$ErrorActionPreference = 'Stop'

$caseDirs = Get-ChildItem -Path $CasesRoot -Directory | Sort-Object Name
if ($caseDirs.Count -eq 0) {
  throw "No case directories found under $CasesRoot"
}

$rows = @()
foreach ($dir in $caseDirs) {
  $caseId = $dir.Name
  $notes = Join-Path $dir.FullName 'case_notes.md'

  if (-not (Test-Path $notes)) {
    Write-Warning "Missing case_notes.md for $caseId. Skipping."
    continue
  }

  $content = Get-Content $notes -Raw

  function Extract-Value {
    param([string]$Text, [string]$Label)
    $regex = [regex]::new("(?im)^\s*-\s*$([regex]::Escape($Label))\s*:\s*(.+)$")
    $m = $regex.Match($Text)
    if ($m.Success) { return $m.Groups[1].Value.Trim() }
    return ''
  }

  $rows += [PSCustomObject]@{
    case_id = $caseId
    product_type = Extract-Value -Text $content -Label 'product_type'
    input_quality = Extract-Value -Text $content -Label 'input_quality'
    input_long_edge_px = Extract-Value -Text $content -Label 'input_long_edge_px'
    preset_tier = Extract-Value -Text $content -Label 'preset_tier'
    recipe = Extract-Value -Text $content -Label 'recipe'
    classification = Extract-Value -Text $content -Label 'classification'
    blocker_defect = Extract-Value -Text $content -Label 'blocker_defect'
    tolerable_defect = Extract-Value -Text $content -Label 'tolerable_defect'
    runtime_seconds = Extract-Value -Text $content -Label 'runtime_seconds'
    reviewer = Extract-Value -Text $content -Label 'reviewer'
    notes = Extract-Value -Text $content -Label 'notes'
  }
}

$rows | Export-Csv -Path $OutputCsv -NoTypeInformation -Encoding UTF8
Write-Host "Wrote QA CSV: $OutputCsv"
