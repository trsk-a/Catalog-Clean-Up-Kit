# QA Execution Playbook (10 Cases)

## Goal
Execute 10 real in-scope product cases and classify each output as:
- approved
- usable_with_revision
- out_of_scope

## Case Mix (Recommended)
- 2 boxes
- 2 bottles (opaque/semi-opaque)
- 2 gadgets
- 2 pouches/semi-rigid items
- 2 edge/surface-challenging but still in-scope items

## Per-Case Procedure
1. Validate input against `INPUT_ACCEPTANCE_RULES.md`.
2. Select VRAM preset by hardware tier.
3. Run main workflow.
4. Run neutral background workflow.
5. Run export/validation workflow for ratios.
6. Evaluate against `OUTPUT_ACCEPTANCE_RULES.md`.
7. Record defects using `DEFECT_CLASSIFICATION.md`.
8. Fill case notes + CSV row.

## Required Artifacts Per Case
- `input_original.*`
- `output_main.*`
- `output_neutral_bg.*`
- `output_1x1.*`
- `output_4x5.*`
- `output_9x16.*`
- `case_notes.md`

## Release Gate
Minimum launch recommendation:
- 7+ approved
- <= 3 usable_with_revision
- 0 blocker defects unresolved
