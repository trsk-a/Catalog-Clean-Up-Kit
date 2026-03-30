# Next Steps (Execution Order)

1. Freeze dependencies from actual ComfyUI environment:
   - `./tools/freeze_dependencies.ps1 -ComfyUIPath <path>`
2. Fill each `08_EXAMPLES/BEFORE_AFTER/case_XX/` with required files and notes.
3. Build QA CSV from case notes:
   - `./tests/qa_matrix/build_qa_csv_from_cases.ps1`
4. Run smoke tests:
   - `./tests/smoke/run_all_smoke.ps1`
5. Run release gates:
   - `./release/qa_and_freeze_gate.ps1`
6. Build distributable beta ZIP:
   - `./release/build_beta_package.ps1 -Version v1-beta`
