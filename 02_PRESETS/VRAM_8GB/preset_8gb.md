# Preset 8GB

Use this profile when VRAM is constrained.

## Goals
- Avoid OOM failures.
- Keep predictable runtime.
- Preserve product shape before detail enhancement.

## Recommended Settings
- Steps: 16-20
- CFG: 3.8-4.4
- Denoise: 0.28-0.35
- Max long edge input: 1600 px

## Red Flags
- Repeated OOM: reduce long edge to 1344 px.
- Deformation: lower denoise and CFG slightly.
