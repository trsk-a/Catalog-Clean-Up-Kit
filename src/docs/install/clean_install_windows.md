# Clean Install - Windows

## Prerequisites
- NVIDIA GPU (8 GB minimum for constrained tier)
- Compatible CUDA stack
- Python 3.10.x
- Fresh ComfyUI directory

## Steps
1. Clone/download ComfyUI to a clean folder.
2. Install Python deps required by pinned ComfyUI commit.
3. Install pinned custom nodes only.
4. Download required models to documented paths.
5. Copy CCKU workflows/presets/recipes.
6. Launch ComfyUI and load `ccuk_v1_main_core.json`.
7. Run post-install validation checklist.

## If Fails
- Check missing nodes/models first.
- Check version mismatch second.
- Check VRAM preset mismatch third.
