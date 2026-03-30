param(
  [Parameter(Mandatory = $true)]
  [string]$ComfyUIPath,
  [string]$OutputRoot = '.'
)

$ErrorActionPreference = 'Stop'

function Get-GitShaOrPlaceholder {
  param([string]$Path)

  if (-not (Test-Path $Path)) {
    return 'NOT_FOUND'
  }

  try {
    $sha = git -C $Path rev-parse HEAD 2>$null
    if ([string]::IsNullOrWhiteSpace($sha)) { return 'NOT_A_GIT_REPO' }
    return $sha.Trim()
  }
  catch {
    return 'NOT_A_GIT_REPO'
  }
}

function Get-GitRemoteOrPlaceholder {
  param([string]$Path)

  try {
    $url = git -C $Path remote get-url origin 2>$null
    if ([string]::IsNullOrWhiteSpace($url)) { return 'UNKNOWN_REMOTE' }
    return $url.Trim()
  }
  catch {
    return 'UNKNOWN_REMOTE'
  }
}

$comfySha = Get-GitShaOrPlaceholder -Path $ComfyUIPath

$customNodesPath = Join-Path $ComfyUIPath 'custom_nodes'
$nodeRows = @()

if (Test-Path $customNodesPath) {
  Get-ChildItem -Path $customNodesPath -Directory | ForEach-Object {
    $nodePath = $_.FullName
    $nodeRows += [PSCustomObject]@{
      name = $_.Name
      path = $nodePath
      remote = (Get-GitRemoteOrPlaceholder -Path $nodePath)
      commit = (Get-GitShaOrPlaceholder -Path $nodePath)
      required_for_v1 = 'review_required'
    }
  }
}

$comfyOut = Join-Path $OutputRoot '04_DEPENDENCIES/COMFYUI_VERSION.txt'
$lockOut = Join-Path $OutputRoot '04_DEPENDENCIES/CUSTOM_NODES_LOCKFILE.md'

Set-Content -Path $comfyOut -Encoding UTF8 -Value $comfySha

$lockLines = @()
$lockLines += '# Custom Nodes Lockfile (Generated)'
$lockLines += ''
$lockLines += "Generated on: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lockLines += "ComfyUI path: $ComfyUIPath"
$lockLines += ''

if ($nodeRows.Count -eq 0) {
  $lockLines += 'No custom node directories found.'
}
else {
  $lockLines += '| Node | Remote | Commit | Required For V1 |'
  $lockLines += '|---|---|---|---|'
  foreach ($row in $nodeRows) {
    $lockLines += "| $($row.name) | $($row.remote) | $($row.commit) | $($row.required_for_v1) |"
  }
}

Set-Content -Path $lockOut -Encoding UTF8 -Value ($lockLines -join "`r`n")

Write-Host "Wrote $comfyOut"
Write-Host "Wrote $lockOut"
