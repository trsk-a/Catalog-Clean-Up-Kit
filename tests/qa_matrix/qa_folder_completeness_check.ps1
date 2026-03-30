param(
  [string]$CasesRoot = '08_EXAMPLES/BEFORE_AFTER'
)

$ErrorActionPreference = 'Stop'

$required = @(
  'input_original',
  'output_main',
  'output_neutral_bg',
  'output_1x1',
  'output_4x5',
  'output_9x16',
  'case_notes.md'
)

$caseDirs = Get-ChildItem -Path $CasesRoot -Directory | Sort-Object Name
if ($caseDirs.Count -eq 0) {
  throw "No case directories found under $CasesRoot"
}

$errors = @()

foreach ($dir in $caseDirs) {
  $files = Get-ChildItem -Path $dir.FullName -File | Select-Object -ExpandProperty Name
  foreach ($req in $required) {
    if ($req -eq 'case_notes.md') {
      if (-not ($files -contains $req)) {
        $errors += "$($dir.Name): missing case_notes.md"
      }
    }
    else {
      $match = $files | Where-Object { $_ -like "$req.*" }
      if (-not $match) {
        $errors += "$($dir.Name): missing file with prefix '$req'"
      }
    }
  }
}

if ($errors.Count -gt 0) {
  throw ("QA folder completeness failed:`n" + ($errors -join "`n"))
}

Write-Host 'QA folder completeness check passed.'
