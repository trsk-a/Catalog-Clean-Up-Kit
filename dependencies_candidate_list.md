# Dependencies Candidate List (To Freeze Before Final QA)

## ComfyUI Base
- ComfyUI (single frozen commit/tag for V1 release)

## Custom Nodes (Candidate, Minimal Set)
- Impact Pack (utility image ops)
- WAS Node Suite (convenience image transforms)
- ComfyUI-Manager (installation convenience, optional for final users)
- Background/segmentation helper nodes (only if stable and maintained)

## Model Categories (Exact files frozen in compatibility matrix)
- Base image model (SDXL-class or equivalent supported by chosen stack)
- VAE
- Optional refiner (16+ GB tier priority)
- Optional LoRA set for controlled clean-up behavior
- Optional inpaint support model

## Selection Rules
- Keep node count minimal.
- Prefer actively maintained repos.
- Avoid exotic or brittle nodes.
- Every dependency must have reproducible install notes.

## Freeze Gate
This list is candidate-only until moved into:
- `04_DEPENDENCIES/COMPATIBILITY_MATRIX.md`
- `04_DEPENDENCIES/CUSTOM_NODES_LOCKFILE.md`
- `04_DEPENDENCIES/MODELS_REQUIRED.md`
