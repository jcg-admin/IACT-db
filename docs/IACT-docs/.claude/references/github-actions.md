```yml
type: Reference
title: GitHub Actions Integration
category: Desarrollo — CI/CD
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Automatizar code reviews, issue triage y quality gates con anthropics/claude-code-action
```

# GitHub Actions Integration

Referencia para automatizar code reviews, issue triage y quality gates conectando Claude directamente a workflows de GitHub mediante `anthropics/claude-code-action`.

> **Action:** `anthropics/claude-code-action@v1` — Oficial de Anthropic, 6.2k stars.
> Repositorio: [github.com/anthropics/claude-code-action](https://github.com/anthropics/claude-code-action)

## Comparación de los 5 patterns

| Pattern | Trigger | Caso de uso | Costo aprox. / run |
|---------|---------|-------------|--------------------|
| **PR review on @mention** | Comentario con `@claude` | Reviews on-demand, preguntas, fixes | $0.05–0.15 (Sonnet) |
| **Automatic PR review on push** | `pull_request: opened/synchronize` | Quality gate continuo sin fricción | $0.05–0.15 (Sonnet) |
| **Issue triage** | `issues: opened` | Clasificación y etiquetado automático | $0.01–0.03 (Haiku) |
| **Security-focused review** | `pull_request` en paths sensibles | Auditoría de auth, pagos, config | $0.10–0.25 (Sonnet) |
| **Scheduled maintenance** | `schedule` (cron) | Health check semanal, dependencias | $0.05–0.20 (Sonnet) |

Fuente: github-actions.md:61–67, 343–349

---

## Setup

### Quickstart (30 segundos)

Desde el terminal de Claude Code, dentro de cualquier proyecto conectado a GitHub:

```
/install-github-app
```

Guía el proceso: crea el GitHub App, agrega `ANTHROPIC_API_KEY` a los secrets del repo y genera el workflow base `claude.yml`.

### Manual

1. Agregar `ANTHROPIC_API_KEY` a los secrets del repositorio
2. Crear `.github/workflows/claude.yml` (ver patterns abajo)
3. Otorgar permisos al workflow: `contents: write`, `pull-requests: write`, `issues: write`

Fuente: github-actions.md:72–87

---

## Pattern 1: PR Review on @claude Mention

Iniciado por humano. El desarrollador comenta `@claude review this PR` y Claude responde inline.

```yaml
# .github/workflows/claude-review.yml
name: Claude Interactive Review
on:
  issue_comment:
    types: [created, edited]
  pull_request_review_comment:
    types: [created]

jobs:
  claude:
    if: |
      contains(github.event.comment.body, '@claude') ||
      contains(github.event.review_comment.body, '@claude')
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
      issues: write
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          claude_env: |
            GITHUB_TOKEN=${{ secrets.GITHUB_TOKEN }}
```

**Ejemplos de uso:**
- `@claude review this PR` — análisis completo del diff con sugerencias
- `@claude is this change backwards compatible?` — pregunta puntual
- `@claude fix the failing test in src/auth.test.ts` — Claude abre un PR con el fix

Fuente: github-actions.md:90–125

---

## Pattern 2: Automatic PR Review on Push

Cada PR recibe una review al abrirse o actualizarse. Sin mención requerida.

```yaml
# .github/workflows/claude-auto-review.yml
name: Claude Auto PR Review
on:
  pull_request:
    types: [opened, synchronize]
    # Opcional: solo activar en paths específicos
    # paths:
    #   - 'src/**'
    #   - '!**/*.md'

jobs:
  claude-review:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Review this pull request. Focus on:
            - Logic errors and edge cases
            - Security issues (injection, auth, secrets)
            - Performance regressions
            - Missing error handling

            Format your response as:
            ## Summary
            One paragraph describing the change.

            ## Issues Found
            Numbered list, severity (Critical/Major/Minor), file:line reference.

            ## Suggestions
            Optional improvements.

            Keep it under 400 words. Be direct.
```

**Tips:**
- Agregar `paths:` para evitar disparos en PRs de solo docs
- Usar `if: github.event.pull_request.draft == false` para omitir drafts

Fuente: github-actions.md:128–173

---

## Pattern 3: Issue Triage and Labeling

Claude lee los issues nuevos, asigna labels y posta un comentario de triage estructurado.

```yaml
# .github/workflows/claude-triage.yml
name: Issue Triage
on:
  issues:
    types: [opened]

jobs:
  triage:
    runs-on: ubuntu-latest
    permissions:
      issues: write
      contents: read
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Triage this GitHub issue:

            1. Assign one label from: bug, enhancement, question, documentation, performance, security
            2. Assign a priority label: priority:critical, priority:high, priority:medium, priority:low
            3. Post a comment with:
               - Issue type classification
               - Which component is likely affected (based on the issue description)
               - Next step recommendation for the reporter (reproduce steps needed? version info missing?)

            Be brief. One sentence per point.
```

Fuente: github-actions.md:177–209

---

## Pattern 4: Security-Focused Review

Se activa específicamente para PRs que tocan paths sensibles (auth, pagos, config).

```yaml
# .github/workflows/claude-security.yml
name: Security Review
on:
  pull_request:
    paths:
      - 'src/auth/**'
      - 'src/payments/**'
      - '**/config/**'
      - '**/.env*'
      - '**/secrets/**'

jobs:
  security-review:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Perform a security-focused review of this PR. Check for:

            - Injection vulnerabilities (SQL, command, LDAP)
            - Authentication and authorization bypasses
            - Secrets or credentials in code or comments
            - Insecure direct object references
            - Missing input validation
            - Unsafe deserialization
            - OWASP Top 10 patterns

            Rate overall risk: Low / Medium / High / Critical.
            If High or Critical, add the label 'security-review-required'.
            List each finding with: file:line, vulnerability type, and recommended fix.
```

Fuente: github-actions.md:213–253

---

## Pattern 5: Scheduled Maintenance

Health check semanal — corre sin ningún trigger humano.

```yaml
# .github/workflows/claude-maintenance.yml
name: Weekly Repo Health Check
on:
  schedule:
    - cron: '0 9 * * 1'  # Cada lunes a las 9am UTC
  workflow_dispatch:       # También permite disparo manual

jobs:
  maintenance:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      issues: write
    steps:
      - uses: actions/checkout@v4

      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Perform a weekly repository health check:

            1. Scan package.json (or equivalent) for outdated major dependencies
            2. Check for TODO/FIXME comments older than 30 days in src/
            3. Identify any test files without corresponding implementation files
            4. List any documentation files that reference deleted or renamed files

            Open a GitHub issue titled "Weekly Health Check - [date]" with your findings.
            If nothing requires attention, post a comment "Health check passed — no issues found."
```

Fuente: github-actions.md:257–291

---

## Autenticación

Los ejemplos anteriores usan `ANTHROPIC_API_KEY` directamente. Para equipos en cloud providers:

### Amazon Bedrock

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    use_bedrock: 'true'
  env:
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    AWS_REGION: us-east-1
    ANTHROPIC_MODEL: 'anthropic.claude-3-5-sonnet-20241022-v2:0'
```

### Google Vertex AI

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    use_vertex: 'true'
  env:
    ANTHROPIC_VERTEX_PROJECT_ID: ${{ secrets.GCP_PROJECT_ID }}
    CLOUD_ML_REGION: us-east5
    ANTHROPIC_MODEL: 'claude-3-5-sonnet-v2@20241022'
```

Los cloud providers permiten data residency compliance y aprovechar IAM policies existentes en lugar de gestionar una API key separada.

Fuente: github-actions.md:296–323

---

## Control de costos

Los workflows automatizados corren sin un humano en el loop — definir límites explícitos.

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    # Cap de gasto por run
    claude_args: '--max-budget-usd 0.50'
```

### Budget por pattern

| Pattern | Modelo recomendado | Costo aprox. / run |
|---------|-------------------|--------------------|
| PR review (PR mediano) | Sonnet | $0.05–0.15 |
| Issue triage | Haiku | $0.01–0.03 |
| Security review (PR grande) | Sonnet | $0.10–0.25 |
| Scheduled maintenance | Sonnet | $0.05–0.20 |

Monitorear gasto real con `ccusage` o el dashboard de Anthropic Console.

### Evitar runaway costs

```yaml
# Prevenir runs paralelos en el mismo PR
jobs:
  claude-review:
    concurrency:
      group: claude-${{ github.event.pull_request.number }}
      cancel-in-progress: true
```

- Usar `paths:` para evitar disparos en cambios irrelevantes
- Agregar `if: github.event.pull_request.draft == false` para omitir draft PRs
- Usar Haiku para triage, Sonnet para reviews — no defaultear a Opus

Fuente: github-actions.md:327–363

---

## Security checklist

Antes de deployar a un repo de equipo:

- [ ] `ANTHROPIC_API_KEY` guardado como GitHub secret, nunca en el YAML del workflow
- [ ] Permisos del workflow son mínimos — usar `contents: read` salvo que se necesiten escrituras
- [ ] Para repos públicos: agregar `if: github.event.pull_request.head.repo.full_name == github.repository` para prevenir que PRs de forks disparen API calls
- [ ] Revisar qué posta el workflow públicamente — los comentarios de Claude son visibles para todos los contributors
- [ ] Usar `pull_request_target` con cautela — corre con permisos de escritura incluso desde forks

### Fork safety pattern (repos públicos)

```yaml
jobs:
  claude:
    # Solo correr en PRs del mismo repo, no de forks
    if: github.event.pull_request.head.repo.full_name == github.repository
```

Fuente: github-actions.md:368–383

---

## Ejemplo de workflow completo

Workflow listo para copiar — combina interactive review con control de concurrencia y fork safety:

```yaml
# .github/workflows/claude.yml
name: Claude Code Review
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]

jobs:
  claude:
    # Solo en PRs del mismo repo (fork safety)
    if: |
      github.event.pull_request.head.repo.full_name == github.repository &&
      (contains(github.event.comment.body, '@claude') ||
       contains(github.event.review_comment.body, '@claude'))
    runs-on: ubuntu-latest
    # Prevenir runs paralelos en el mismo PR
    concurrency:
      group: claude-${{ github.event.pull_request.number }}
      cancel-in-progress: true
    permissions:
      contents: write
      pull-requests: write
      issues: write
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          claude_args: '--max-budget-usd 0.50'
          claude_env: |
            GITHUB_TOKEN=${{ secrets.GITHUB_TOKEN }}
```

Fuente: github-actions.md:34–53, 356–383

---

## Referencias

- [scheduled-tasks](scheduled-tasks.md) — modo headless (`claude -p`), integración CI/CD sin action
- [Official action docs](https://github.com/anthropics/claude-code-action) — solutions guide, migration, cloud providers
- [Community workflow blueprint](https://github.com/alirezarezvani/claude-code-github-workflow) — 8 workflows + 4 autonomous agents
