$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path
$ver = (Get-Content (Join-Path $root 'VERSION') -Raw).Trim()
$staging = Join-Path $env:TEMP ("orq-sx-v{0}" -f ($ver -replace '\.', ''))
$inner = Join-Path $staging 'orquestador-sx'
if (Test-Path $staging) { Remove-Item $staging -Recurse -Force }
New-Item -ItemType Directory -Path $inner -Force | Out-Null
& robocopy $root $inner /E /XD .git .lab tooling\bench\worktrees tooling\bench\results /XF *.zip /NFL /NDL /NJH /NJS | Out-Null
$zipName = "orquestador-sx-v$ver.zip"
$zip = Join-Path $root $zipName
if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path (Join-Path $inner '*') -DestinationPath $zip -Force
$hash = (Get-FileHash $zip -Algorithm SHA256).Hash.ToLowerInvariant()
"$hash  $zipName" | Set-Content (Join-Path $root 'SHA256SUMS') -Encoding ASCII -NoNewline
Add-Content (Join-Path $root 'SHA256SUMS') ''
Write-Host "SHA256: $hash"
Write-Host "Zip: $zip"
