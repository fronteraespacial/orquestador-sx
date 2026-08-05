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


## Invitar colaboradores

Repo **privado** (`fronteraespacial/spacex-orchestrator`): antes de compartir [`FIRST-RUN.md`](../human/FIRST-RUN.md) o el zip, cada persona necesita acceso al repo u org.

**Regla:** el maintainer debe indicar **usernames o emails concretos**. **No ejecutar invites reales** desde scripts o agentes si no hay lista explícita aprobada.

### Comprobar autenticación (maintainer)

```powershell
gh auth status
gh api user
```

Debe responder con el usuario/org owner que puede invitar.

### Invitar al repositorio (colaborador directo)

Sustituí `GITHUB_USERNAME` por el login exacto (minúsculas). Permisos típicos: `pull` (solo lectura) o `push` (maintainers).

```powershell
gh api `
  repos/fronteraespacial/spacex-orchestrator/collaborators/GITHUB_USERNAME `
  -X PUT `
  -f permission=pull
```

Listar colaboradores actuales:

```powershell
gh api repos/fronteraespacial/spacex-orchestrator/collaborators --jq '.[].login'
```

### Invitar a la organización (opcional)

Si el equipo entra por org `fronteraespacial`, usá invitación por email (requiere permisos de org owner):

```powershell
gh api orgs/fronteraespacial/invitations `
  -f email=persona@example.com `
  -f role=direct_member
```

Invitación por username (si la org lo permite en vuestro plan):

```powershell
gh api orgs/fronteraespacial/invitations `
  -f invitee_id=$(gh api users/GITHUB_USERNAME --jq .id) `
  -f role=direct_member
```

Listar invitaciones pendientes:

```powershell
gh api orgs/fronteraespacial/invitations
```

### Alternativa interactiva

```powershell
gh repo edit fronteraespacial/spacex-orchestrator --add-collaborator GITHUB_USERNAME
```

### Después del invite

1. Confirmar que la persona aceptó (Settings → Collaborators / email de invitación org).
2. Que ejecute `gh auth login` con una cuenta que vea `fronteraespacial/spacex-orchestrator`.
3. Compartir [`TEAM-SHARE.md`](../human/TEAM-SHARE.md) (Slack/mail).

## Rollback

- No re-tag force en `main`.
- Publicar patch `vX.Y.Z+1` con fix; usuarios aplican `update --apply`.

## Notas

- **No** incluir secretos, `MODELS.local.md`, ni `tooling/bench/results/` en el zip.
- Stubs root del pack Windows pueden archivarse tras un ciclo de release estable.
