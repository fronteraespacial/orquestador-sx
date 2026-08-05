# Release process

Procedimiento maintainer para publicar **fronteraespacial/spacex-orchestrator**.

## Flujo tag → zip → SHA256SUMS → invite

### 1. Pre-release checklist

Ver [`DISTRIBUTION-CHECKLIST.md`](DISTRIBUTION-CHECKLIST.md):

```powershell
.\tooling\scripts\Validate-OrchestratorPack.ps1 -Strict
```

### 2. Version bump

- Editar [`VERSION`](../../VERSION) (SemVer).
- Entrada en [`CHANGELOG.md`](../../CHANGELOG.md).

### 3. Tag

```powershell
git tag v1.1.0
git push origin v1.1.0
```

El workflow `.github/workflows/release.yml` (on tag `v*`) empaqueta y sube assets.

### 4. Artefactos de release

| Asset | Contenido |
|-------|-----------|
| `spacex-orchestrator-vX.Y.Z.zip` | Pack completo excluyendo `tooling/bench/worktrees`, `tooling/bench/results`, `.lab/` opcional |
| `SHA256SUMS` | Formato GNU: `hash  filename` (dos espacios) |

Generación manual (si hace falta fuera de CI):

```powershell
# Desde raíz del pack
$ver = (Get-Content VERSION -Raw).Trim()
$zip = "spacex-orchestrator-v$ver.zip"
# Excluir worktrees, results, .lab al zippear
Compress-Archive -Path * -DestinationPath $zip
$hash = (Get-FileHash $zip -Algorithm SHA256).Hash.ToLowerInvariant()
"$hash  $zip" | Set-Content SHA256SUMS -Encoding ASCII
```

### 5. GitHub release

```powershell
gh release create v1.1.0 $zip SHA256SUMS --repo fronteraespacial/spacex-orchestrator --title "v1.1.0" --notes-file CHANGELOG-snippet.md
```

Repo **privado** — invitar colaboradores con acceso read antes de compartir `FIRST-RUN.md`.

### 6. Verificación post-release

```powershell
.\tooling\scripts\Orchestrator.ps1 update --check -TargetPath C:\path\to\test-repo
.\tooling\scripts\Orchestrator.ps1 update --apply -TargetPath C:\path\to\test-repo
```

Debe verificar SHA256SUMS y reescribir `.orchestrator-lock.json` con `source: release`.

## Rollback

- No re-tag force en `main`.
- Publicar patch `vX.Y.Z+1` con fix; usuarios aplican `update --apply`.

## Notas

- **No** incluir secretos, `MODELS.local.md`, ni `tooling/bench/results/` en el zip.
- Stubs root del pack Windows pueden archivarse tras un ciclo de release estable.
