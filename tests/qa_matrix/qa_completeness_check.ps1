param(
  [string]$CsvPath = 'tests/qa_matrix/qa_case_template.csv'
)

$ErrorActionPreference = 'Stop'

$requiredColumns = @(
  'case_id',
  'product_type',
  'input_quality',
  'input_long_edge_px',
  'preset_tier',
  'recipe',
  'classification',
  'runtime_seconds',
  'reviewer'
)

$rows = Import-Csv -Path $CsvPath
foreach ($row in $rows) {
  foreach ($col in $requiredColumns) {
    if (-not ($row.PSObject.Properties.Name -contains $col)) {
      throw "Missing required column '$col'"
    }
    if ([string]::IsNullOrWhiteSpace($row.$col)) {
      throw "Incomplete row '$($row.case_id)': column '$col' is empty"
    }
  }
}

Write-Host 'QA completeness check passed.'
