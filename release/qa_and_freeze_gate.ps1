$ErrorActionPreference = 'Stop'

Write-Host 'Running smoke test suite...'
& 'tests/smoke/run_all_smoke.ps1'

Write-Host 'Running placeholder check...'
& 'tests/release/no_placeholders_smoke.ps1'

Write-Host 'Running QA CSV completeness check...'
& 'tests/qa_matrix/qa_completeness_check.ps1'

Write-Host 'Running QA summary gate...'
& 'tests/qa_matrix/qa_summary.ps1'

Write-Host 'All release gates passed.'
