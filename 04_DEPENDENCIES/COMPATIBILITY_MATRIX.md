# Compatibility Matrix (V1 Freeze)

## Status
Draft freeze for beta. Final release must pin exact commit SHAs and model file hashes.

## Base
- ComfyUI: `PIN_ME_COMMIT_SHA`
- Python: `3.10.x` (recommended)
- CUDA: `PIN_ME_CUDA_VERSION`

## OS
- Windows: supported on clean install path.
- Linux: supported on clean install path.
- Existing environments: limited support with disclaimers.

## Custom Nodes (Pinned)
| Node Repo | Version/Commit | Required | Notes |
|---|---|---|---|
| ComfyUI-Manager | PIN_ME | optional | install helper |
| Impact-Pack | PIN_ME | optional | only if used in final graphs |
| WAS Node Suite | PIN_ME | optional | avoid if not required |
| Segmentation helper | PIN_ME | optional | include only if QA-proven |

## Models (Pinned)
| Artifact | Filename | Hash | Required |
|---|---|---|---|
| Base checkpoint | PIN_ME.safetensors | PIN_ME | yes |
| VAE | PIN_ME.vae.safetensors | PIN_ME | yes |
| Refiner | PIN_ME.safetensors | PIN_ME | optional (16+ GB) |
| Inpaint model | PIN_ME.safetensors | PIN_ME | optional |

## Freeze Rule
No dependency updates during beta except blocker bugs.
