# Compatibility Matrix (V1 Freeze)

## Status
Frozen for beta on 2026-03-30 using local environment capture.

## Base
- ComfyUI: `portable build at D:\ComfyUI (not a git checkout)`
- ComfyUI identifier: `NOT_A_GIT_REPO`
- Python: `3.12.6`
- NVIDIA Driver: `591.74`
- CUDA Runtime: `13.1`
- GPU reference used for validation: `NVIDIA GeForce RTX 2080 Ti (11264 MiB)`

## OS
- Windows: supported on clean install path.
- Linux: supported on clean install path.
- Existing environments: limited support with disclaimers.

## Custom Nodes (Pinned Snapshot)
Source lockfile: `04_DEPENDENCIES/CUSTOM_NODES_LOCKFILE.md`

| Node Repo | Version/Commit | Required | Notes |
|---|---|---|---|
| ComfyUI-Manager | `26da78cf15f99e6c083b6ea140e1833e5323f51b` | optional | install helper only |
| ComfyUI_IPAdapter_plus | `a0f451a5113cf9becb0847b92884cb10cbdec0ef` | optional | not required by default V1 templates |
| Additional local node folders without git metadata | `NOT_A_GIT_REPO` | no | keep disabled unless explicitly required by workflow |

## Models (Pinned)
| Artifact | Filename | SHA256 | Required |
|---|---|---|---|
| Base checkpoint | `sd_xl_base_1.0.safetensors` | `31E35C80FC4829D14F90153F4C74CD59C90B779F6AFE05A74CD6120B893F7E5B` | yes |
| VAE | `ae.safetensors` | `AFC8E28272CD15DB3919BACDB6918CE9C1ED22E96CB12C4D5ED0FBA823529E38` | yes |
| Refiner | `sd_xl_refiner_1.0.safetensors` | `7440042BBDC8A24813002C09B6B69B64DC90FDED4472613437B7F55F9B7D9C5F` | optional (16+ GB) |
| Alternate stylistic base (optional) | `JuggernautXL.safetensors` | `33E58E86686F6B386C526682B5DA9228EAD4F91D994ABD4B053442DC5B42719E` | optional |
| Inpaint model | `wan2.2_fun_inpaint_5B_bf16.safetensors` | `not pinned in V1 core` | optional/not required |

## Freeze Rule
No dependency updates during beta except blocker bugs.
