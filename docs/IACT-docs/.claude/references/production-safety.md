```yml
type: Reference
title: Production Safety — Reglas No-Negociables para Entornos Productivos
category: Claude Code Platform — Seguridad
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Reglas no-negociables para equipos que usan Claude Code en entornos productivos
```

# Production Safety

Reglas no-negociables para equipos que usan Claude Code en entornos productivos.
No aplican a prototipos individuales ni entornos de aprendizaje — ver tabla de contexto abajo.

Fuente: production-safety.md:1–36

---

## Resumen ejecutivo — Las 6 reglas

| Regla | Que protege | Implementacion principal |
|-------|-------------|--------------------------|
| 1. Port Stability | Coordinacion entre devs y deploys | `permissions.deny` en settings.json |
| 2. Database Safety | Datos en produccion (irreversible) | Hook PreToolUse + backup script |
| 3. Feature Completeness | Calidad en produccion, no deuda oculta | CLAUDE.md constraints + pre-commit hook |
| 4. Infrastructure Lock | Estabilidad de infraestructura compartida | `permissions.deny` en settings.json |
| 5. Dependency Safety | Bundle size, licencias, seguridad | `permissions.deny` en Bash package managers |
| 6. Pattern Following | Consistencia del codebase, mantenibilidad | CLAUDE.md conventions + post-tool warnings |

---

## Cuando aplica cada regla

Fuente: production-safety.md:29–35

| Contexto | Reglas aplicables |
|----------|-------------------|
| Learning / tutoriales | Ninguna — demasiado restrictivo para explorar |
| Solo dev, prototipo | Ninguna — el overhead no vale |
| Equipo pequeno (2–3), staging | Reglas 1, 3, 6 unicamente |
| App en produccion, equipo multi-dev | Las 6 reglas |
| Industrias reguladas (HIPAA, SOC2) | Las 6 reglas + reglas de compliance adicionales |

---

## Regla 1: Port Stability

Fuente: production-safety.md:39–115

### Que protege

Cambiar puertos rompe: entornos locales de todos los devs, configuraciones Docker Compose,
configs de servicios desplegados y setups de teammates. Un cambio de 3000 → 8080 puede
costar un dia de re-configuracion al equipo y hacer fallar despliegues silenciosamente.

### Implementacion A — Permission deny (recomendado para equipos)

```json
{
  "permissions": {
    "deny": [
      "Edit(docker-compose.yml:*ports*)",
      "Edit(package.json:*PORT*)",
      "Edit(.env.example:*PORT*)",
      "Edit(vite.config.ts:*port*)"
    ]
  }
}
```

### Implementacion B — PreToolUse hook

```bash
# .claude/hooks/PreToolUse.sh
if [[ "$TOOL" == "Edit" ]]; then
    FILE=$(echo "$INPUT" | jq -r '.tool.input.file_path')
    CONTENT=$(echo "$INPUT" | jq -r '.tool.input.new_string')

    if [[ "$FILE" =~ (docker-compose|vite.config|package.json) ]] && \
       [[ "$CONTENT" =~ (port|PORT):[[:space:]]*[0-9] ]]; then
        echo "BLOCKED: Port modification detected in $FILE" >&2
        echo "Ports must remain stable across team. Request permission first." >&2
        exit 2
    fi
fi
```

### Implementacion C — CLAUDE.md

```markdown
## Port Configuration

**CRITICAL**: Ports are locked for team coordination.

Current ports:
- Frontend (Vite): 5173
- Backend (Express): 3000
- Database: 5432

To change ports:
1. Create RFC document in `/docs/rfcs/`
2. Get team approval (3+ reviewers)
3. Update all environments simultaneously
4. Notify team 48h in advance
```

### Casos limite

| Escenario | Comportamiento |
|-----------|----------------|
| Agregar nuevo servicio | Permitido (no rompe existentes) |
| Cambiar puerto de test env | Permitido (aislado de dev/prod) |
| Conflicto de puerto en maquina local | Resolver en `.env.local` (gitignored) |

---

## Regla 2: Database Safety

Fuente: production-safety.md:118–243

### Que protege

Operaciones destructivas sobre datos de produccion son irreversibles.
`DELETE FROM users` sin `WHERE` borra todos los usuarios. `DROP TABLE sessions` en produccion
elimina datos en vivo. Migraciones sin backup dejan sin rollback.

Operaciones que requieren backup previo obligatorio:
- `DELETE FROM` (sin `LIMIT 1`)
- `DROP TABLE`
- `TRUNCATE`
- `ALTER TABLE ... DROP COLUMN`
- Migraciones sin rollback

### Implementacion A — PreToolUse hook con enforcement de backup

```bash
# .claude/hooks/PreToolUse.sh
#!/bin/bash
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool.name')

if [[ "$TOOL" == "Bash" ]]; then
    COMMAND=$(echo "$INPUT" | jq -r '.tool.input.command')

    if [[ "$COMMAND" =~ (DROP TABLE|DELETE FROM|TRUNCATE|ALTER.*DROP) ]]; then
        echo "BLOCKED: Destructive database operation detected" >&2
        echo "" >&2
        echo "Required steps:" >&2
        echo "1. Create backup: pg_dump -U user dbname > backup_\$(date +%Y%m%d_%H%M%S).sql" >&2
        echo "2. Verify backup size is reasonable" >&2
        echo "3. Re-run after backup confirmation" >&2
        exit 2
    fi
fi

exit 0
```

### Implementacion B — Migration safety wrapper

```bash
# scripts/safe-migrate.sh
#!/bin/bash
set -e

# 1. Check environment
if [[ "$NODE_ENV" == "production" ]]; then
    echo "BLOCKED: Use migration service for production"
    exit 1
fi

# 2. Create backup
BACKUP_FILE="backups/pre-migration-$(date +%Y%m%d_%H%M%S).sql"
mkdir -p backups
pg_dump $DATABASE_URL > "$BACKUP_FILE"
echo "Backup created: $BACKUP_FILE"

# 3. Run migration
npm run prisma:migrate:dev

# 4. Verify
npm run prisma:validate

echo "Migration complete. Backup: $BACKUP_FILE"
```

### Implementacion C — MCP database con usuario read-only

Si usas MCP database servers, conectar con credenciales de solo lectura:

```json
{
  "mcpServers": {
    "database": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_URL": "postgres://readonly:***@dev-db.example.com:5432/appdb"
      }
    }
  }
}
```

---

## Regla 3: Feature Completeness

Fuente: production-safety.md:247–344

### Que protege

Claude Code puede "resolver a medias" cuando el contexto se acaba:
borra validacion existente en lugar de corregirla, deja `TODO` en logica core,
agrega `throw new Error("Not implemented")`, genera mocks en paths de produccion.

### Implementacion A — CLAUDE.md (constraint directive)

```markdown
## Feature Implementation Standards

### NON-NEGOTIABLE

1. **No TODOs for core functionality**
   - TODOs allowed ONLY for future enhancements
   - Core features must be complete and working

2. **No mock implementations**
   - No `throw new Error("Not implemented")`
   - No fake data generators in production code paths

3. **Complete error handling**
   - Every async call has try/catch
   - Every user input is validated
   - Every API call has timeout and retry logic

4. **Downgrade = Delete the feature entirely**
   - If you can't fix properly, remove the feature
   - Document why in commit message
   - Create issue for proper implementation
```

### Implementacion B — Pre-commit git hook

```bash
# .git/hooks/pre-commit
#!/bin/bash

STAGED=$(git diff --cached --name-only --diff-filter=ACM)

for FILE in $STAGED; do
    if [[ "$FILE" =~ \.(ts|tsx|js|jsx|py)$ ]]; then
        if ! [[ "$FILE" =~ test|spec ]]; then
            if git diff --cached "$FILE" | grep -E "^\+.*TODO.*implement|^\+.*Not implemented"; then
                echo "COMMIT BLOCKED: TODO/Not implemented in $FILE"
                echo "   Complete the feature or remove it entirely."
                exit 1
            fi
        fi

        if git diff --cached "$FILE" | grep -E "^\+.*(MOCK_DATA|fakeData|placeholder)"; then
            echo "WARNING: Mock data detected in $FILE"
            echo "   Ensure this is intentional for staging/dev only."
        fi
    fi
done

exit 0
```

---

## Regla 4: Infrastructure Lock

Fuente: production-safety.md:348–408

### Que protege

Modificaciones a infra sin entender implicaciones productivas:
cambios a volumes en Docker Compose provocan perdida de datos,
cambios en `.env.example` rompen onboarding de nuevos devs,
cambios en Terraform pueden crear o destruir recursos reales.

Archivos a proteger:
- `docker-compose.yml`, `Dockerfile`
- `.env.example` (templates — NO `.env.local` personal)
- `kubernetes/`, `k8s/`, `terraform/`, `helm/`
- CI/CD configs (`.github/workflows/`, `.gitlab-ci.yml`)
- Schemas de base de datos (`prisma/schema.prisma`)

### Implementacion A — Permission deny (recomendado)

```json
{
  "permissions": {
    "deny": [
      "Edit(docker-compose.yml)",
      "Edit(Dockerfile)",
      "Edit(.env.example)",
      "Edit(terraform/**)",
      "Edit(kubernetes/**)",
      "Edit(.github/workflows/**)",
      "Edit(prisma/schema.prisma)"
    ]
  }
}
```

### Implementacion B — CLAUDE.md rule

```markdown
## Infrastructure Changes

You are **FORBIDDEN** from modifying these without explicit permission:

- `docker-compose.yml`, `Dockerfile`
- `.env.example` (template for new developers)
- `terraform/`, `kubernetes/` (infrastructure as code)
- `.github/workflows/` (CI/CD pipelines)
- `prisma/schema.prisma` (database schema)

**If infrastructure change is needed**:
1. Ask user: "This requires infrastructure change. Should I create an RFC?"
2. Create RFC document in `docs/rfcs/YYYYMMDD-<title>.md`
3. Do NOT modify files until RFC approved
```

**Nota**: Los archivos `.env.local` personales estan bien para modificar (son gitignored).

---

## Regla 5: Dependency Safety

Fuente: production-safety.md:410–503

### Que protege

Agregar dependencias sin aprobacion aumenta bundle size, introduce vulnerabilidades de
seguridad, crea problemas de license compliance y suma carga de mantenimiento.
Ejemplos reales: `moment.js` (200KB) cuando `date-fns` ya estaba en el proyecto;
libreria GPL en codebase propietario — violation de licencia.

### Implementacion A — Permission deny en package managers (recomendado)

```json
{
  "permissions": {
    "deny": [
      "Bash(npm install *)",
      "Bash(npm i *)",
      "Bash(pnpm add *)",
      "Bash(yarn add *)",
      "Bash(pip install *)",
      "Bash(poetry add *)"
    ],
    "allow": [
      "Bash(npm install)",
      "Bash(pnpm install)",
      "Bash(pip install -r requirements.txt)"
    ]
  }
}
```

### Implementacion B — CLAUDE.md protocol

```markdown
## Dependency Management

### Immutable Stack Rule

**You are FORBIDDEN from adding new dependencies** (`npm install <package>`).

**If new dependency is needed**:
1. Check if existing dependency solves it (date-fns, axios, zustand, etc.)
2. If genuinely needed, ASK:
   - "I need [package] for [reason]. Existing alternatives: [X, Y]. Should I add it?"
3. Wait for explicit approval
4. User will run: `npm install <package>` manually

**Allowed without asking**:
- `npm install` (installs existing package.json deps)
- Dev dependencies for testing (`-D` flag after approval)
```

### Implementacion C — PreToolUse hook

```bash
# .claude/hooks/PreToolUse.sh
if [[ "$TOOL" == "Bash" ]]; then
    COMMAND=$(echo "$INPUT" | jq -r '.tool.input.command')

    if [[ "$COMMAND" =~ (npm|pnpm|yarn)[[:space:]]+(install|add|i)[[:space:]]+[a-zA-Z] ]]; then
        echo "BLOCKED: New dependency installation" >&2
        echo "" >&2
        echo "Dependencies must be approved. Create RFC explaining:" >&2
        echo "1. Why this dependency is needed" >&2
        echo "2. Alternatives considered" >&2
        echo "3. Bundle size impact" >&2
        echo "4. License compatibility" >&2
        exit 2
    fi
fi
```

---

## Regla 6: Pattern Following

Fuente: production-safety.md:508–641

### Que protege

Claude puede introducir patrones inconsistentes con el codebase: class components en un
proyecto functional React, `fetch` cuando el proyecto usa `axios`, endpoints REST en un
proyecto GraphQL. Cada inconsistencia es deuda tecnica que degrada mantenibilidad.

### Implementacion A — CLAUDE.md tech stack lock (recomendado)

```markdown
## Code Conventions

### Tech Stack (DO NOT DEVIATE)

**Frontend**:
- React 18 with **function components + hooks** (NO class components)
- State: Zustand (NOT Redux, Context)
- HTTP: axios (NOT fetch)
- Styling: Tailwind CSS (NOT styled-components, emotion)
- Forms: React Hook Form + Zod

**Backend**:
- Node.js + Express
- Database: Prisma ORM (NOT raw SQL, TypeORM)
- Auth: JWT via jose library
- Validation: Zod schemas

**Testing**:
- Unit: Vitest (NOT Jest)
- E2E: Playwright (NOT Cypress)
```

### Implementacion B — Pre-implementation analysis en CLAUDE.md

```markdown
## Before Implementing

**ALWAYS** run these checks:

1. **Pattern check**:
   ```bash
   rg "import.*useState" src/   # Check React patterns
   rg "axios\." src/            # Check HTTP patterns
   rg "prisma\." src/           # Check DB patterns
   ```

2. **Existing components**:
   ```bash
   find src/shared/components -name "*Button*"
   find src/shared/components -name "*Modal*"
   ```

3. **Ask user if unclear**:
   - "I see project uses [X]. Should I follow this pattern or use [Y]?"
```

### Implementacion C — PostToolUse hook de validacion

```bash
# .claude/hooks/PostToolUse.sh
#!/bin/bash
if [[ "$TOOL" == "Write" ]] || [[ "$TOOL" == "Edit" ]]; then
    FILE=$(echo "$INPUT" | jq -r '.tool.input.file_path')

    if [[ "$FILE" =~ \.(tsx?)$ ]]; then
        CONTENT=$(cat "$FILE")

        if echo "$CONTENT" | grep -q "class.*extends.*Component"; then
            echo "WARNING: Class component detected in $FILE"
            echo "   Project uses function components. Consider refactoring."
        fi

        if echo "$CONTENT" | grep -q "import.*fetch\|window.fetch"; then
            echo "WARNING: fetch() detected in $FILE"
            echo "   Project uses axios. Use: import axios from 'axios'"
        fi
    fi
fi
```

---

## Regla 7: Verification Paradox (autonomous/CI)

Fuente: production-safety.md:645–794

### Que protege

Cuando Claude Code acierta el 95%+ del tiempo, el humano reduce inconscientemente
la calidad del review ("el AI siempre lo hace bien"). El 5% de errores pasa exactamente
porque el humano baja la guardia. La solucion es automatizar la verificacion rutinaria
y reservar atencion humana para decisiones arquitectonicas.

### Implementacion A — CI/CD guardrail stack

```yaml
# .github/workflows/ai-safety.yml
name: AI Output Validation

on: [pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - name: Type safety
        run: npm run typecheck

      - name: Lint rules
        run: npm run lint

      - name: Unit tests
        run: npm run test

      - name: E2E tests
        run: npm run test:e2e

      - name: Security audit
        run: npm audit

      - name: Bundle analysis
        run: npm run analyze

      # Human review ONLY after all automation passes
```

### Implementacion B — Verification protocol en CLAUDE.md

```markdown
## Verification Protocol

### NEVER rely on human review alone

**Automated verification required**:
1. **Type safety**: `npm run typecheck` must pass (zero errors)
2. **Tests**: `npm run test` coverage >= 80% for new code
3. **Lint**: `npm run lint` must pass (zero warnings)
4. **Security**: `npm audit` must show zero high/critical vulnerabilities

**Human review is for**:
- Architecture decisions
- UX/design choices
- Business logic validation

**Human review is NOT for**:
- Syntax errors (use linters)
- Type errors (use TypeScript)
- Performance regressions (use benchmarks)
- Security issues (use automated scanners)
```

### Implementacion C — PreCommit hook automatizado

```bash
# .claude/hooks/PreCommit.sh
#!/bin/bash

echo "Running automated verification..."

npm run typecheck || { echo "Type errors detected" >&2; exit 1; }
npm run lint || { echo "Lint errors detected" >&2; exit 1; }
npm run test || { echo "Tests failing" >&2; exit 1; }
npm audit --audit-level=high || { echo "Security vulnerabilities detected" >&2; exit 1; }

echo "All automated checks passed"
echo "Human review can now focus on architecture/UX/business logic"
```

---

## Regla extra: Autonomous Loop Safety

Fuente: production-safety.md:978–1086

### Que protege

Sesiones autonomas (sin supervision humana) pueden quedar atascadas en un loop sin
salida: sin error, sin exit code, consumiendo API budget silenciosamente. Ademas,
matar solo el proceso padre deja procesos hijo huerfanos ejecutando acciones sin
supervision.

### Implementacion — Heartbeat + watchdog

**Hook PostToolUse (heartbeat writer)**:

```bash
#!/bin/bash
# .claude/hooks/autonomous-heartbeat.sh
HEARTBEAT_FILE="${CLAUDE_HEARTBEAT_FILE:-/tmp/claude-heartbeat-$$}"
date +%s > "$HEARTBEAT_FILE"
```

**Script watchdog (proceso separado)**:

```bash
#!/bin/bash
# scripts/watchdog.sh
# Usage: ./scripts/watchdog.sh <timeout_seconds> <pid>

TIMEOUT="${1:-30}"
TARGET_PID="${2:-}"
HEARTBEAT_FILE="${CLAUDE_HEARTBEAT_FILE:-/tmp/claude-heartbeat-$TARGET_PID}"

while true; do
  sleep 5

  if ! kill -0 "$TARGET_PID" 2>/dev/null; then
    echo "Watchdog: process $TARGET_PID has exited cleanly"
    exit 0
  fi

  if [[ -f "$HEARTBEAT_FILE" ]]; then
    LAST_BEAT=$(cat "$HEARTBEAT_FILE")
    NOW=$(date +%s)
    AGE=$(( NOW - LAST_BEAT ))

    if [[ "$AGE" -gt "$TIMEOUT" ]]; then
      echo "Watchdog: no heartbeat for ${AGE}s (limit: ${TIMEOUT}s) -- killing process group"
      kill -TERM -"$TARGET_PID" 2>/dev/null || kill -TERM "$TARGET_PID"
      sleep 2
      kill -KILL -"$TARGET_PID" 2>/dev/null || true
      rm -f "$HEARTBEAT_FILE"
      exit 1
    fi
  fi
done
```

**Launch script**:

```bash
#!/bin/bash
export CLAUDE_HEARTBEAT_FILE="/tmp/claude-heartbeat-$$"

claude --print "Process the task queue in tasks.json" &
CLAUDE_PID=$!

./scripts/watchdog.sh 30 "$CLAUDE_PID" &
WATCHDOG_PID=$!

wait "$CLAUDE_PID"
EXIT_CODE=$?

kill "$WATCHDOG_PID" 2>/dev/null
rm -f "$CLAUDE_HEARTBEAT_FILE"
exit "$EXIT_CODE"
```

### Timeout recomendado por tipo de tarea

| Tipo de tarea | Timeout recomendado |
|---------------|---------------------|
| Operaciones de archivo simples | 15–30s |
| HTTP requests, API calls | 60s |
| Compilacion, test runs | 120s |
| Research tasks de larga duracion | 300s |

No usar para: sesiones interactivas, tareas bajo 5 minutos, pipelines con retry logic.

---

## Metodos de enforcement — Comparativa

Fuente: production-safety.md:940–946

| Metodo | Strictness | Setup | Mejor para |
|--------|------------|-------|------------|
| `permissions.deny` | 100% (bloquea) | 2 min | Reglas criticas (1, 2, 4) |
| PreToolUse hook | 100% (bloquea) | 10 min | Logica custom, reglas de equipo |
| CLAUDE.md rules | ~70% (Claude respeta) | 5 min | Convenciones, guidelines |
| PostToolUse warnings | ~30% (advierte solo) | 5 min | Best practices, sugerencias |
| Git hooks | 100% (bloquea commits) | 15 min | Safety net final antes de push |

---

## Anti-patrones en produccion

| Anti-patron | Por que es peligroso | Alternativa |
|-------------|----------------------|-------------|
| Confiar en review manual como unica barrera | Vigilance fatigue -- el 1% de errores pasa cuando el humano baja la guardia | CI/CD automatizado obligatorio |
| Agregar dependencias "temporales" sin approval | Se quedan permanentes y aumentan attack surface | Permission deny + RFC obligatorio |
| Cambiar puertos en caliente | Rompe todos los entornos del equipo silenciosamente | Port lock en settings.json |
| Dejar TODOs en logica core | Deuda oculta que llega a produccion como bug | Pre-commit hook + CLAUDE.md constraint |
| Conectar MCP a DB con usuario admin | Una query destructiva borra datos de produccion | Usuario read-only para MCP siempre |
| Matar solo proceso padre en loops autonomos | Procesos hijo huerfanos ejecutan acciones sin supervision | Kill del process group completo |
| Overrides temporales sin expiry date | Se convierten en overrides permanentes | Siempre agregar fecha de expiracion al override |

---

## Configuracion por tamano de equipo

Fuente: production-safety.md:860–868

| Tamano de equipo | Reglas recomendadas |
|------------------|---------------------|
| 1–2 devs | Reglas 1, 3, 6 |
| 3–10 devs | Reglas 1, 3, 5, 6 |
| 10+ devs o produccion | Las 6 reglas + Regla 7 |

---

## Overrides temporales — Como hacerlos bien

Para situaciones excepcionales donde se necesita flexibilidad puntual:

**Con expiry en CLAUDE.md**:
```markdown
## Temporary Override (expires 2026-05-01)
For this feature only: infrastructure changes allowed.
Reason: Setting up new microservice.
After expiry: revert to standard rules.
```

**Con exception granular en settings.json**:
```json
{
  "permissions": {
    "allow": ["Edit(docker-compose.dev.yml)"],
    "deny": ["Edit(docker-compose.prod.yml)"]
  }
}
```

**Require confirmation en lugar de bloquear**:
```json
{
  "permissions": {
    "ask": ["Bash(rm -rf *)", "Bash(DROP TABLE *)"]
  }
}
```

---

## Distribucion de reglas al equipo

Las reglas en `.claude/settings.json` y `CLAUDE.md` commitadas al repo son automaticamente
compartidas. Los overrides personales van en archivos gitignored:

```
/project/.claude/settings.json        # Commitado -- reglas del equipo
/project/CLAUDE.md                    # Commitado -- convenciones del equipo
/project/.claude/settings.local.json  # Gitignored -- overrides personales
```

---

## Ver tambien

- [hooks](hooks.md) -- Configuracion de PreToolUse, PostToolUse, exit codes, matchers
- [permission-model](permission-model.md) -- Allow/deny rules, jerarquia de permisos
- [security-hardening](security-hardening.md) -- MCP security, secret protection
