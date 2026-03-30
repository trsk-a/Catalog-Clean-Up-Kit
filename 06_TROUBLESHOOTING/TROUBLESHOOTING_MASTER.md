# Troubleshooting Master

## Decision Tree (Fast)
1. Does workflow open?
   - No -> check missing nodes/models/version mismatch.
2. Does run complete?
   - No -> check VRAM preset and resolution envelope.
3. Does output pass checklist?
   - No -> branch to edge/shadow/deformation/artificial look guides.

## Top Issues
- Missing nodes
- Missing models
- OOM/VRAM crash
- Bad edges/halos
- Fake shadows
- Deformation
- Artificial look
- Blur output
- Version conflicts

## Classification
- Blocker: cannot run or repeated unusable output in-scope.
- Tolerable: minor tune needed, documented in preset/recipe guides.
