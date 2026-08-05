$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path
$staging = Join-Path $env:TEMP 'orq-sx-v120'
$inner = Join-Path $staging 'orquestador-sx'
if (Test-Path $staging) { Remove-Item $staging -Recurse -Force }
New-Item -ItemType Directory -Path $inner -Force | Out-Null
& robocopy $root $inner /E /XD .git .lab tooling\bench\worktrees tooling\bench\results /XF *.zip /NFL /NDL /NJH /NJS | Out-Null
$zip = Join-Path $root 'orquestador-sx-v1.2.0.zip'
if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path (Join-Path $inner '*') -DestinationPath $zip -Force
$hash = (Get-FileHash $zip -Algorithm SHA256).Hash.ToLowerInvariant()
"$hash  orquestador-sx-v1.2.0.zip" | Set-Content (Join-Path $root 'SHA256SUMS') -Encoding ASCII -NoNewline
Add-Content (Join-Path $root 'SHA256SUMS') ''
Write-Host "SHA256: $hash"
Write-Host "Zip: $zip"
