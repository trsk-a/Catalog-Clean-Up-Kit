# Catalog Clean-Up Kit V1

Catalog Clean-Up Kit V1 is a narrow, reproducible ComfyUI system to improve product photos of rigid or semi-rigid objects for catalog, e-commerce marketplace, and static social usage.

## Master Decision
Build and launch **Catalog Clean-Up Kit V1 first**. Do not build a universal kit, complex lifestyle workflows, or specialized vertical kits first.

## Core Promise
Improve product photos for catalog, online store, and social using a pre-built ComfyUI system that is installable, documented, and tuned by hardware tier.

## Scope Gates
- In scope: product clean-up workflow, neutral background workflow, export/validation workflow, VRAM presets, recipes/prompts, dependency matrix, install docs, troubleshooting docs, QA matrix, 10 real cases.
- Out of scope: jewelry complexity, fashion-on-body, difficult transparencies, high-end reflectives as primary promise, critical microtypography packaging, complex lifestyle scenes.

## Bundle Layout
- Product bundle docs/assets: `00_START_HERE` to `10_COMMERCIAL` + `LICENSE`
- Technical source area: `src/`, `tests/`, `release/`, `tools/`

## Build Status
- [x] Scope freeze artifacts
- [x] Functional architecture map
- [x] Candidate dependency strategy
- [x] Initial workflow JSON templates
- [x] VRAM presets draft
- [x] Install/troubleshooting/QA docs draft
- [x] Smoke tests and beta ZIP builder
- [ ] Dependency freeze with real SHAs/hashes
- [ ] Real 10-case production QA execution
- [ ] Final release ZIP export

## Fast Commands
- Run smoke suite: `./tests/smoke/run_all_smoke.ps1`
- Build beta ZIP: `./release/build_beta_package.ps1 -Version v1-beta`
- Generate dependency lock from real environment: `./tools/freeze_dependencies.ps1 -ComfyUIPath <path>`
- Run full gate (after QA/freeze complete): `./release/qa_and_freeze_gate.ps1`

## Definition of Done (Global)
The project is done when the V1 pack is downloadable, installable, reproducible in supported environments, validated with 10 real cases, and explicitly limited to its narrow promise.
