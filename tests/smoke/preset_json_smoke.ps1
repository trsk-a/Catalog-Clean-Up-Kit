$ErrorActionPreference = 'Stop'

$presetFiles = @(
  '02_PRESETS/VRAM_8GB/preset_8gb.json',
  '02_PRESETS/VRAM_12GB/preset_12gb.json',
  '02_PRESETS/VRAM_16GB_PLUS/preset_16gb_plus.json'
)

$requiredTopLevel = @('preset_id', 'vram_tier', 'target', 'defaults')
$requiredDefaults = @('steps', 'cfg', 'denoise', 'batch_size', 'resolution_max_long_edge')

foreach ($file in $presetFiles) {
  if (-not (Test-Path $file)) {
    throw "Missing preset file: $file"
  }

  $json = Get-Content $file -Raw | ConvertFrom-Json

  foreach ($key in $requiredTopLevel) {
    if (-not ($json.PSObject.Properties.Name -contains $key)) {
      throw "Missing key '$key' in $file"
    }
  }

  foreach ($key in $requiredDefaults) {
    if (-not ($json.defaults.PSObject.Properties.Name -contains $key)) {
      throw "Missing defaults key '$key' in $file"
    }
  }
}

Write-Host 'Preset JSON smoke test passed.'
