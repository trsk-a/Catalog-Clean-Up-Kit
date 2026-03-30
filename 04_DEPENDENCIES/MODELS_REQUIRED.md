# Models Required

## Required (V1 Core)
- Base checkpoint: `sd_xl_base_1.0.safetensors`
  - SHA256: `31E35C80FC4829D14F90153F4C74CD59C90B779F6AFE05A74CD6120B893F7E5B`
- VAE: `ae.safetensors`
  - SHA256: `AFC8E28272CD15DB3919BACDB6918CE9C1ED22E96CB12C4D5ED0FBA823529E38`

## Optional
- Refiner (16+ GB tier): `sd_xl_refiner_1.0.safetensors`
  - SHA256: `7440042BBDC8A24813002C09B6B69B64DC90FDED4472613437B7F55F9B7D9C5F`
- Alternate base look: `JuggernautXL.safetensors`
  - SHA256: `33E58E86686F6B386C526682B5DA9228EAD4F91D994ABD4B053442DC5B42719E`
- Inpaint support model: optional, not pinned for V1 core release gate.

## Policy
Do not bundle non-redistributable model files in release package.
Provide download instructions and integrity checks only.
