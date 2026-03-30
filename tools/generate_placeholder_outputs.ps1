param(
  [string]$CasesRoot = '08_EXAMPLES/BEFORE_AFTER'
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

function Save-CenterCropResize {
  param(
    [System.Drawing.Image]$Image,
    [double]$TargetRatio,
    [int]$OutW,
    [int]$OutH,
    [string]$Path
  )

  $srcW = $Image.Width
  $srcH = $Image.Height
  $srcRatio = [double]$srcW / [double]$srcH

  if ($srcRatio -gt $TargetRatio) {
    $cropH = $srcH
    $cropW = [int]([math]::Round($srcH * $TargetRatio))
  }
  else {
    $cropW = $srcW
    $cropH = [int]([math]::Round($srcW / $TargetRatio))
  }

  $cropX = [int]([math]::Floor(($srcW - $cropW) / 2))
  $cropY = [int]([math]::Floor(($srcH - $cropH) / 2))

  $bmp = New-Object System.Drawing.Bitmap $OutW, $OutH
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

  $srcRect = New-Object System.Drawing.Rectangle $cropX, $cropY, $cropW, $cropH
  $dstRect = New-Object System.Drawing.Rectangle 0, 0, $OutW, $OutH
  $g.DrawImage($Image, $dstRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
  $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Jpeg)

  $g.Dispose()
  $bmp.Dispose()
}

$caseDirs = Get-ChildItem -Path $CasesRoot -Directory | Sort-Object Name
foreach ($dir in $caseDirs) {
  $input = Get-ChildItem -Path $dir.FullName -File | Where-Object { $_.Name -like 'input_original.*' } | Select-Object -First 1
  if (-not $input) {
    Write-Warning "Skipping $($dir.Name): missing input_original.*"
    continue
  }

  $outMain = Join-Path $dir.FullName 'output_main.jpg'
  $outNeutral = Join-Path $dir.FullName 'output_neutral_bg.jpg'
  Copy-Item -Path $input.FullName -Destination $outMain -Force
  Copy-Item -Path $input.FullName -Destination $outNeutral -Force

  $img = [System.Drawing.Image]::FromFile($input.FullName)
  Save-CenterCropResize -Image $img -TargetRatio 1.0 -OutW 1080 -OutH 1080 -Path (Join-Path $dir.FullName 'output_1x1.jpg')
  Save-CenterCropResize -Image $img -TargetRatio 0.8 -OutW 1080 -OutH 1350 -Path (Join-Path $dir.FullName 'output_4x5.jpg')
  Save-CenterCropResize -Image $img -TargetRatio 0.5625 -OutW 1080 -OutH 1920 -Path (Join-Path $dir.FullName 'output_9x16.jpg')
  $img.Dispose()

  $notePath = Join-Path $dir.FullName 'case_notes.md'
  if (Test-Path $notePath) {
    $content = Get-Content $notePath -Raw
    $content = $content -replace '(?m)^- preset_tier:[ \t]*.*$', '- preset_tier: pending_run'
    $content = $content -replace '(?m)^- recipe:[ \t]*.*$', '- recipe: pending_run'
    $content = $content -replace '(?m)^- classification:[ \t]*.*$', '- classification: pending_workflow_run'
    $content = $content -replace '(?m)^- runtime_seconds:[ \t]*.*$', '- runtime_seconds: 0'
    $content = $content -replace '(?m)^- notes:[ \t]*.*$', '- notes: placeholder outputs generated from input only (no ComfyUI inference yet)'
    if ($content -notmatch '(?m)^- reviewer:') {
      $content = $content -replace '(?m)^- notes:', "- reviewer: codex_preload`r`n- notes:"
    }
    Set-Content -Path $notePath -Value $content -Encoding UTF8
  }

  Write-Host "Prepared placeholders for $($dir.Name)"
}

Write-Host 'Placeholder output generation completed.'
