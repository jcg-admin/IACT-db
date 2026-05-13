```yml
created_at: 2026-04-27 23:28:26
project: IACT-docs
analysis_version: 1.0
author: NestorMonroy
status: Borrador
```

# Phase 1 DISCOVER — Deployment Pipeline para Documentación IACT

**WP:** `2026-04-27-23-28-26-deployment-pipeline`
**Branch base:** `feature/repository-diagnostics` (con build limpio 0 warnings)
**Origen del WP:** conversación 27-abr donde el ejecutor confirmó que actualmente la documentación se entrega bajando HTML manualmente al servidor interno.

---

## Pregunta de la fase

¿Cómo entregar la documentación HTML de Sphinx a producción de forma automatizada, segura y reversible, eliminando el paso manual actual?

---

## Estado actual (proceso "as-is")

Confirmado por el ejecutor en conversación:

| Aspecto | Cómo es hoy |
|---------|-------------|
| Acceso a docs | Vía URL (servidor interno) |
| Origen de los HTML servidos | Bajada manual de `build/html/` por el operador |
| Quién hace el deploy | Manual, persona-dependiente |
| Trazabilidad de versión deployada | Ninguna formal — el operador sabe |
| Backup antes de overwrite | Si lo hay, manual |
| Validación post-deploy | Manual / inexistente |
| Rollback en caso de error | Manual / improvisado |

**Anti-patrón observado:** se commiteaban los archivos `build/` al repo (commit `5dc6a40 chore(build): regenerate HTML output...`). Eso engorda `.git/` (64 MB), no es la fuente real de producción, y ya fue des-trackeado en F-01 del WP repository-diagnostics. Pero la limpieza histórica está bloqueada hasta que un pipeline real reemplace el flujo manual.

---

## Estado actual del CI (`.github/workflows/sphinx-build.yml`)

```yaml
on:
  pull_request: branches: [main]
  push:        branches: [main]
jobs:
  build:
    - checkout
    - install dependencies (pip install -e .)
    - cd source && make clean && make html
    - upload-artifact (success)  # 7 días retención
    - upload-artifact (failure)  # 7 días retención
```

Lo que **sí hace**:

- Validar que `make html` no falle.
- Subir el output como artifact de GitHub Actions (descargable manualmente).

Lo que **NO hace**:

- No usa `-W` → warnings se ignoran.
- No valida links rotos.
- No valida PlantUML.
- No deploya a ningún servidor.
- No corre en push a `develop` (solo a `main`).
- No corre en feature branches (solo a PR contra `main`).

**Hueco crítico:** el deploy queda fuera del pipeline.

---

## Estado actual de la infraestructura (declarado por el ejecutor + CNST_008)

- Servidor on-premise (no cloud, no contenedores).
- Apache (con mod_wsgi para parte backend según CNST_008).
- Sin pipeline de deploy automático declarado en repo.
- Posible existencia de servidor staging — **a confirmar**.
- URL de docs en producción — **a confirmar**.

---

## Stakeholders

| Rol | Interés | Nivel |
|-----|---------|-------|
| **NestorMonroy** (ejecutor) | Eliminar pasos manuales, garantizar 0 warnings se mantiene | Alto |
| **Lectores de la doc** (equipo IACT) | URL siempre disponible y actualizada | Alto |
| **Operador del servidor on-premise** | Acceso SSH controlado, backups automáticos | Alto |
| **CI/GitHub Actions** | Pipeline mantenible, secretos protegidos | Medio |
| **Equipo de seguridad** | SSH keys gestionadas, no leakeadas | Alto |
| **Auditoría / compliance** | Trazabilidad de qué versión está en prod en cada momento | Alto |

---

## Restricciones aplicables (constraints existentes)

- **CNST-001:** notificaciones por buzón interno — el pipeline NO puede notificar por email, debe usar buzón interno o webhook hacia una cola interna.
- **CNST-005:** RBAC y SoD — el usuario que asigna el deploy NO debe ser el que audita el deploy. Implica usuarios separados o approval externo.
- **CNST-008:** infraestructura on-premise, sin contenedores, deployment por paquete ZIP. El pipeline debe producir `.tar.gz` o `.zip`.
- **CNST-009:** auditoría inmutable — cada deploy debe registrar quién/cuándo/qué versión.

---

## Diseño propuesto del pipeline (alto nivel)

Tres GitHub Actions workflows secuenciales:

### 1. `validate.yml` — corre en PR + push a feature/develop

**Trigger:** `pull_request: [develop, main]` + `push: ['feature/**', 'develop']`

**Jobs:**

- Setup Python + uv + libenchant.
- `bash scripts/setup.sh`.
- `make clean && sphinx-build -W -b html ...` (warnings as errors).
- `sphinx-build -b linkcheck ...` (link broken check).
- `bash scripts/validate-plantuml.sh`.

**Resultado:** PASS bloquea o permite el merge.

### 2. `deploy-staging.yml` — corre al merge en develop

**Trigger:** `push: [develop]`.

**Jobs:**

- Build (mismo que validate).
- Empaquetar: `iact-docs-staging-{git_sha}.tar.gz`.
- SSH al servidor staging:
  - Backup actual: `cp -r /var/www/iact-docs /var/www/iact-docs.backup-{timestamp}`.
  - Vaciar y desempaquetar nuevo.
  - `chown www-data`.
- Health-check: `curl -f https://docs-staging.iact.local/`.

### 3. `deploy-production.yml` — corre al push de tag `v*`

**Trigger:** `push: tags: ['v*']`.

**Jobs:**

- Mismo build.
- Empaquetar versionado: `iact-docs-{tag}.tar.gz`.
- Environment con manual approval (GitHub `environments`).
- SSH al servidor producción:
  - Backup actual.
  - Deploy.
  - Health-check.
  - Rollback automático si falla.
- Notificación al buzón interno (CNST-001).

### Diagrama de flujo

```
feature/xxx → push
   │
   ▼
validate.yml (CI valida -W) ──► falla → bloquea merge
   │
   ▼ merge a develop
   │
   ▼
deploy-staging.yml ──► falla → ROLLBACK staging
   │
   ▼ merge a main + tag v*
   │
   ▼
manual approval (GitHub environment)
   │
   ▼
deploy-production.yml ──► falla → ROLLBACK prod + notificar buzón
```

---

## Inventario de elementos a crear

### En el repo

- `.github/workflows/validate.yml` (~60 líneas)
- `.github/workflows/deploy-staging.yml` (~80 líneas)
- `.github/workflows/deploy-production.yml` (~100 líneas)
- `scripts/deploy.sh` (helper local — opcional para deploy manual de emergencia)
- `scripts/health-check.sh` (script reusable para validar URL responde 200)
- Documentación: actualizar `readme.rst` y/o crear `source/normativa/procedimientos/PROC-OPS-001-deployment.rst`.

### En GitHub (configuración)

- **Secrets:**
  - `STAGING_SSH_KEY` — clave privada para el servidor staging.
  - `STAGING_HOST` — hostname o IP del servidor staging.
  - `STAGING_USER` — usuario `deploy` en staging.
  - `PROD_SSH_KEY` — clave privada producción.
  - `PROD_HOST`.
  - `PROD_USER`.
- **Environments:**
  - `staging` (sin approval).
  - `production` (con approval manual + reviewers list).

### En los servidores (staging y producción)

- Usuario `deploy` con shell `/bin/bash`.
- SSH pública del usuario `deploy` en `~/.ssh/authorized_keys`.
- Sudoers configurado para que `deploy` pueda manipular `/var/www/iact-docs/`.
- Apache vhost apuntando a `/var/www/iact-docs/`.
- Health-check endpoint disponible (`/index.html` retorna 200 es suficiente).

---

## Riesgos clave (full list en risk-register)

- **R-06:** eliminar `build/` antes del pipeline rompe el acceso actual. Mitigación: postergar limpieza histórica hasta pipeline operativo.
- **R-09:** el ejecutor desconoce el proceso manual actual con detalle. Mitigación: documentarlo en Phase 3 ANALYZE.
- **R-10:** servidor on-premise sin Internet → CI no puede SSH directo. Mitigación: self-hosted runner o jump host.

---

## Síntomas observables HOY

- 64 MB en `.git/` por `build/` legacy commiteado.
- CI valida pero no entrega — el deploy es 100% manual.
- Sin trazabilidad de qué versión está en prod.
- Sin backup automático antes de overwrite.
- Pasos clave dependen de una persona (bus factor = 1).

---

## Datos pendientes de confirmar (entrada para Phase 3 ANALYZE)

1. **URL staging** real.
2. **URL producción** real.
3. **Hostname/IP** de los servidores staging y producción.
4. **¿GitHub Actions tiene salida directa al servidor on-premise?** O hay que usar self-hosted runner / jump host (R-10).
5. **¿Quién opera el deploy hoy?** ¿una persona, una rotación, un team?
6. **¿Existe servidor staging?** Si no, hay que crear o consolidar producción como único destino.
7. **¿Qué se pierde si producción cae 5 min durante deploy?** Define la urgencia del rollback automático.
8. **¿Acceso para crear usuario `deploy` y configurar `authorized_keys`?**

---

## Próximo paso recomendado

**Sequence Mediano:** 1 → 3 → 5 → 6 → 7 → 8 → 9 → 10 → 11.

- **Phase 3 ANALYZE:** documentar el proceso manual actual con fidelidad y profundizar en R-10 (network path GitHub Actions → on-premise).
- **Phase 5 STRATEGY:** decidir entre 3 alternativas — GitHub-hosted runner + jump host, self-hosted runner, o plataforma externa (ReadTheDocs, Netlify) si la infosec lo permite.
- **Phase 6 SCOPE:** definir si el WP entrega solo `validate.yml` (alcance mínimo, no toca servidor) o el pipeline completo de 3 workflows.
- **Phase 9 PILOT:** probar el deploy a staging antes de tocar producción.
- **Phase 10 EXECUTE:** implementar workflows + secrets + scripts servidor.

---

## Restricción de orden (gating)

**Este WP debe completarse ANTES de la limpieza histórica de `build/`** (registrada como pendiente en el WP repository-diagnostics). La limpieza histórica solo es segura cuando el pipeline reemplaza el flujo manual y el acceso a docs no depende del `build/` commiteado.
