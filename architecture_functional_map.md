# Functional Architecture Map (M1-M11)

## M1 Input Ingestion
Validate format/resolution/basic case fitness and pre-classify in-scope vs out-of-scope.

## M2 Normalization
Standardize orientation, resolution envelope, and remove non-essential metadata.

## M3 Preprocess
Apply controlled denoise/contrast prep and optional mask-assist transformations.

## M4 Main Clean-Up
Improve commercial usability while preserving product identity and shape.

## M5 Background Control
Produce neutral background variant and controlled simple background replacement.

## M6 Edge Control
Reduce halos and jagged contours around product boundaries.

## M7 Shadow Control
Apply simple, credible contact shadow behavior.

## M8 Visual Consistency
Enforce stable contrast/sharpness/color behavior across similar inputs.

## M9 VRAM Tier Presets
Switch performance/quality settings by hardware class (8/12/16+ GB).

## M10 Output Validation
Classify output: approved / usable-with-revision / out-of-scope.

## M11 Export
Generate standardized deliverables (1:1, 4:5, 9:16) with naming rules.

## Notes
- V1 prioritizes reproducibility over cinematic output.
- Modules are designed to become reusable subgraphs for V2.
