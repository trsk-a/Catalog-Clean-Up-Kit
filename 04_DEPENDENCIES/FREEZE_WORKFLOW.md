# Dependency Freeze Workflow (Operational)

Use this workflow to replace all `PIN_ME` placeholders with real values captured from your working environment.

## Inputs Required
- Path to ComfyUI root.
- Final list of node repos actually used in workflows.
- Final model filenames and SHA256 hashes.

## Output Files Updated
- `04_DEPENDENCIES/COMFYUI_VERSION.txt`
- `04_DEPENDENCIES/CUSTOM_NODES_LOCKFILE.md`
- `04_DEPENDENCIES/COMPATIBILITY_MATRIX.md`

## Steps
1. Run: `./tools/freeze_dependencies.ps1 -ComfyUIPath <path> -OutputRoot .`
2. Open generated lockfile and review optional nodes; remove unused dependencies.
3. Add model filenames + hashes to `MODELS_REQUIRED.md` and `COMPATIBILITY_MATRIX.md`.
4. Run placeholder check: `./tests/release/no_placeholders_smoke.ps1`.
5. Commit freeze outputs with message: `Freeze V1 dependency matrix`.

## Freeze Gate
Release cannot proceed while any `PIN_ME` remains in dependency docs.
