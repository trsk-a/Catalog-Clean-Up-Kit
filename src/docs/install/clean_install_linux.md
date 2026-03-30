# Clean Install - Linux

## Prerequisites
- NVIDIA driver + CUDA runtime supported by pinned stack
- Python 3.10.x
- Fresh ComfyUI directory

## Steps
1. Create isolated environment.
2. Install pinned ComfyUI commit.
3. Install only pinned custom nodes.
4. Place required models in expected directories.
5. Copy workflows and preset files.
6. Launch and run one smoke case with 12 GB preset equivalent (or 8 GB fallback).
7. Complete post-install validation.

## Notes
Linux support is clean-install-first. Existing mixed setups are best-effort only.
