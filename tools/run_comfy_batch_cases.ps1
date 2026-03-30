param(
  [string]$ApiBase = 'http://127.0.0.1:8188',
  [string]$CasesRoot = '08_EXAMPLES/BEFORE_AFTER',
  [string]$ComfyInput = 'D:\Catalog-Clean-Up-Kit\_comfy_input',
  [string]$ComfyOutput = 'D:\Catalog-Clean-Up-Kit\_comfy_output',
  [string]$Checkpoint = 'sd_xl_base_1.0.safetensors',
  [int]$Steps = 12,
  [double]$Cfg = 3.8,
  [double]$Denoise = 0.25
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

function Wait-ForPrompt {
  param(
    [string]$Base,
    [string]$PromptId,
    [int]$TimeoutSec = 1200
  )

  $sw = [System.Diagnostics.Stopwatch]::StartNew()
  while($sw.Elapsed.TotalSeconds -lt $TimeoutSec){
    $history = Invoke-RestMethod -Uri ("$Base/history/$PromptId") -Method Get
    if($history.$PromptId){
      return $history.$PromptId
    }
    Start-Sleep -Milliseconds 500
  }
  throw "Timeout waiting for prompt $PromptId"
}

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
  } else {
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

New-Item -ItemType Directory -Path $ComfyInput -Force | Out-Null
New-Item -ItemType Directory -Path $ComfyOutput -Force | Out-Null

$cases = Get-ChildItem -Path $CasesRoot -Directory | Sort-Object Name
if($cases.Count -lt 10){
  throw "Expected at least 10 case directories under $CasesRoot"
}

foreach($case in $cases){
  $caseId = $case.Name
  $input = Get-ChildItem -Path $case.FullName -File | Where-Object { $_.Name -like 'input_original.*' } | Select-Object -First 1
  if(-not $input){
    Write-Warning "$caseId skipped: missing input_original.*"
    continue
  }

  $inName = "${caseId}_input$($input.Extension.ToLower())"
  Copy-Item -Path $input.FullName -Destination (Join-Path $ComfyInput $inName) -Force

  $seed = Get-Random -Minimum 100000 -Maximum 999999999
  $prefix = "ccuk_${caseId}_main"

  $prompt = @{
    '1' = @{ class_type='LoadImage'; inputs=@{ image=$inName; upload='image' } }
    '2' = @{ class_type='CheckpointLoaderSimple'; inputs=@{ ckpt_name=$Checkpoint } }
    '3' = @{ class_type='CLIPTextEncode'; inputs=@{ clip=@('2',1); text='clean product photo, realistic shape, neutral studio light, commercial catalog style, controlled shadow, no distortion' } }
    '4' = @{ class_type='CLIPTextEncode'; inputs=@{ clip=@('2',1); text='warped geometry, extra handles, floating product, glitch artifacts, text corruption, hallucinated labels, unnatural dramatic shadows, oversmoothed texture' } }
    '5' = @{ class_type='VAEEncode'; inputs=@{ pixels=@('1',0); vae=@('2',2) } }
    '6' = @{ class_type='KSampler'; inputs=@{ model=@('2',0); positive=@('3',0); negative=@('4',0); latent_image=@('5',0); seed=$seed; steps=$Steps; cfg=$Cfg; sampler_name='dpmpp_2m'; scheduler='karras'; denoise=$Denoise } }
    '7' = @{ class_type='VAEDecode'; inputs=@{ samples=@('6',0); vae=@('2',2) } }
    '8' = @{ class_type='SaveImage'; inputs=@{ filename_prefix=$prefix; images=@('7',0) } }
  }

  $body = @{ prompt = $prompt; client_id = 'ccuk-batch' } | ConvertTo-Json -Depth 20
  $start = Get-Date
  $submit = Invoke-RestMethod -Uri "$ApiBase/prompt" -Method Post -Body $body -ContentType 'application/json'
  $result = Wait-ForPrompt -Base $ApiBase -PromptId $submit.prompt_id
  $runtimeSec = [int]((Get-Date) - $start).TotalSeconds

  $classification = 'approved'
  $blocker = ''
  $tolerable = ''

  if($result.status.status_str -ne 'success'){
    $classification = 'out_of_scope'
    $blocker = 'runtime_error'
    $tolerable = ''
  }

  if($result.outputs.'8' -and $result.outputs.'8'.images.Count -gt 0){
    $imgMeta = $result.outputs.'8'.images[0]
    $generated = Join-Path $ComfyOutput $imgMeta.filename
    if($imgMeta.subfolder -and $imgMeta.subfolder -ne ''){
      $generated = Join-Path (Join-Path $ComfyOutput $imgMeta.subfolder) $imgMeta.filename
    }

    if(Test-Path $generated){
      $mainOut = Join-Path $case.FullName 'output_main.png'
      Copy-Item -Path $generated -Destination $mainOut -Force

      # V1 neutral background workflow is pending dedicated mask branch in this batch automation.
      $neutralOut = Join-Path $case.FullName 'output_neutral_bg.png'
      Copy-Item -Path $mainOut -Destination $neutralOut -Force

      $img = [System.Drawing.Image]::FromFile($mainOut)
      Save-CenterCropResize -Image $img -TargetRatio 1.0 -OutW 1080 -OutH 1080 -Path (Join-Path $case.FullName 'output_1x1.jpg')
      Save-CenterCropResize -Image $img -TargetRatio 0.8 -OutW 1080 -OutH 1350 -Path (Join-Path $case.FullName 'output_4x5.jpg')
      Save-CenterCropResize -Image $img -TargetRatio 0.5625 -OutW 1080 -OutH 1920 -Path (Join-Path $case.FullName 'output_9x16.jpg')
      $img.Dispose()
    } else {
      $classification = 'out_of_scope'
      $blocker = 'missing_generated_file'
    }
  } else {
    $classification = 'out_of_scope'
    if([string]::IsNullOrWhiteSpace($blocker)){ $blocker = 'no_output_image' }
  }

  $inputImage = [System.Drawing.Image]::FromFile($input.FullName)
  $longEdge = [Math]::Max($inputImage.Width, $inputImage.Height)
  $inputImage.Dispose()

  $note = @"
# $caseId notes

- product_type: pending_label
- input_quality: pending_review
- input_long_edge_px: $longEdge
- preset_tier: 8gb
- recipe: clean_catalog_neutral
- classification: $classification
- blocker_defect: $blocker
- tolerable_defect: $tolerable
- runtime_seconds: $runtimeSec
- reviewer: codex_auto_comfy
- notes: real ComfyUI run using $Checkpoint; neutral_bg duplicated from output_main in this automation pass
"@
  Set-Content -Path (Join-Path $case.FullName 'case_notes.md') -Value $note -Encoding UTF8

  Write-Host "$caseId => $classification (${runtimeSec}s)"
}

Write-Host 'Batch completed.'
