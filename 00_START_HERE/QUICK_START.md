# Quick Start

## Objective
Get first usable output in minimal steps.

## Steps
1. Confirm you are on supported ComfyUI + node versions (compatibility matrix).
2. Open `01_WORKFLOWS/V1_MAIN/ccuk_v1_main_core.json`.
3. Pick your VRAM tier preset from `02_PRESETS`.
4. Load one in-scope image (>=1024 px long edge, recommended 1600-3000).
5. Apply base recipe from `03_RECIPES_AND_PROMPTS/BASE_RECIPES.md`.
6. Run main workflow.
7. If output looks valid, run neutral background variant.
8. Validate against `09_EXPORT/OUTPUT_READY_CHECKLIST.md`.
9. Export to 1:1, 4:5, and 9:16.
10. Classify result as approved / usable-with-revision / out-of-scope.

## Fast Failure Conditions
- OOM error repeatedly with correct preset.
- Missing nodes/models from matrix.
- Severe edge halos or obvious deformation in two consecutive runs.
