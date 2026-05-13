```yml
created_at: 2026-04-27 23:42:03
project: IACT-docs
work_package: 2026-04-27-23-28-26-deployment-pipeline
phase: Phase 3 — DIAGNOSE
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Phase 3 ANALYZE — Redefinición de Scope (post-respuestas del ejecutor)

## Cambio crítico vs. Phase 1 DISCOVER

El ejecutor confirmó en la conversación 27-abr 23:35 que el alcance del WP
es **mucho más acotado** que lo propuesto inicialmente:

| Aspecto | Phase 1 propuso | Ejecutor responde |
|---------|-----------------|-------------------|
| Deploy a staging | Workflow dedicado con SSH | **No aplica** — no hay staging |
| Deploy a producción | Workflow dedicado con SSH | **No aplica** — fuera de scope del WP |
| URLs reales (staging/prod) | Pedidas | **No se proporcionan** |
| Hostnames servidores | Pedidos | **No se proporcionan** |
| Acceso SSH al on-premise | Pedido | **No** — entorno controlado |
| Health-check post-deploy | Pedido | **No aplica** — fuera del WP |
| Rollback automático | Pedido | **No aplica** — fuera del WP |
| Notificación post-deploy | Pedida | **No aplica** — fuera del WP |
| Self-hosted runner / jump host | Discutido | **No aplica** — pipeline NO toca on-premise |
| Operador del deploy | Pedido | "Rotación" — fuera del WP |

## Scope refinado del WP

> **Lo que el WP entrega:** un pipeline en GitHub Actions que cuando hay
> un push de tag `v*` a `main` genera un paquete versionado
> `iact-docs-v{X.Y.Z}.tar.gz` con el HTML construido y lo publica como
> **GitHub Release** descargable.
>
> **Lo que el WP NO entrega:** nada que ocurra después de la creación
> del Release. Quien descargue el `.tar.gz` y lo despliegue al servidor
> on-premise es responsabilidad de la rotación de operación, fuera del
> scope.

## Definición de "WP terminado"

| Criterio | Verificación |
|----------|--------------|
| Push de tag `v1.0.0` a `main` | Trigger del workflow `release.yml` |
| CI ejecuta `make clean && sphinx-build -W` | Exit 0, sin warnings |
| CI empaqueta `iact-docs-v1.0.0.tar.gz` con el HTML | Asset creado |
| GitHub Release `v1.0.0` creado automáticamente | Visible en `/releases` |
| `.tar.gz` adjuntado al Release | Descargable |
| Release notes auto-generadas con commits del rango | Visible en Release |
| Documentado el procedimiento de descarga | `PROC-OPS-001-deployment.rst` |

Cuando los 7 criterios pasen → WP cerrado.

## Diseño revisado del pipeline (2 workflows, no 3)

```
┌──────────────────────────────────────────────────────────┐
│ feature/xxx → push                                        │
└────────────────────┬──────────────────────────────────────┘
                     │
                     ▼
┌──────────────────────────────────────────────────────────┐
│ validate.yml                                              │
│  Trigger: pull_request: [develop, main]                   │
│           push: ['feature/**', 'develop']                 │
│  Steps:                                                   │
│   - bash scripts/setup.sh                                 │
│   - sphinx-build -W (warnings as errors)                  │
│   - sphinx-build -b linkcheck                             │
│   - bash scripts/validate-plantuml.sh                     │
│  Resultado: PASS bloquea/permite merge                    │
└────────────────────┬──────────────────────────────────────┘
                     │ merge a main
                     │ + tag v* (manual o auto)
                     ▼
┌──────────────────────────────────────────────────────────┐
│ release.yml                                               │
│  Trigger: push: tags: ['v*']                              │
│  Steps:                                                   │
│   - bash scripts/setup.sh                                 │
│   - sphinx-build -W (warnings as errors)                  │
│   - tar -czf iact-docs-${TAG}.tar.gz -C build/html .      │
│   - sha256sum > iact-docs-${TAG}.tar.gz.sha256            │
│   - softprops/action-gh-release crea GitHub Release       │
│   - Adjunta .tar.gz + .sha256                             │
│   - Auto-genera release notes desde commits Tim Pope      │
│  Resultado: GitHub Release v{X.Y.Z} con asset descargable │
└───────────────────────────────────────────────────────────┘
                     │
                     ▼
        [La rotación descarga y despliega — fuera del WP]
```

## Decisiones técnicas a tomar

### D1 — ¿Quién crea el tag `v*`?

| Opción | Descripción | Trade-off |
|--------|-------------|-----------|
| **A** Manual: `git tag v1.0.0 && git push origin v1.0.0` | Persona decide cuándo cortar release | Control total, requiere recordar |
| **B** Semantic-release automático en cada merge a `main` | Bot lee commits y bumpea versión | Sin intervención, requiere disciplina commit-style |
| **C** Workflow dispatch manual (botón en UI) | Botón "Create Release" en GitHub | UX clara, no requiere CLI |

**Recomendación:** **Opción A** — encaja con el commit-style Tim Pope ya adoptado, sin agregar herramientas. Cuando madure el proceso, migrar a B/C.

### D2 — ¿Qué versión inicial?

`pyproject.toml` ya declara `version = "1.0.0"`. Hay que decidir:

| Opción | Versión del primer release |
|--------|---------------------------|
| **A** `v1.0.0` directo | Refleja el estado declarado en pyproject |
| **B** `v0.1.0` (pre-1.0) | Indica "en desarrollo" |
| **C** `v1.1.0` | Bump menor por agregar pipeline + CNST_012 |

**Recomendación:** **Opción C — `v1.1.0`** porque este pipeline + CNST_012 + zero-warnings es mejora MINOR sobre el estado declarado v1.0.0. El branch `main` actual NO tiene aún esos cambios → el primer release será desde la PR mergeada.

### D3 — ¿Qué incluye el `.tar.gz`?

| Opción | Contenido |
|--------|-----------|
| **A** Solo `build/html/` (~25 MB) | Listo para servir tal cual |
| **B** `build/html/` + `LICENSE` + `readme.rst` | Auto-contenido legalmente |
| **C** `build/html/` + `LICENSE` + `readme.rst` + `CHANGELOG.md` | Trazabilidad incluida |

**Recomendación:** **Opción C** — al desplegar, el operador ve qué versión es y qué cambió.

### D4 — ¿Checksum?

Adjuntar `iact-docs-v{X.Y.Z}.tar.gz.sha256` permite al operador verificar
integridad. **Recomendado: SÍ.**

### D5 — Release notes

| Opción | Cómo |
|--------|------|
| **A** Auto-generadas por GitHub (commits desde último tag) | Default de `softprops/action-gh-release` |
| **B** Manual: workflow lee `CHANGELOG.md` raíz y publica esa sección | Más control, más trabajo |
| **C** Híbrido: auto + sección custom prepended | Lo mejor de ambos |

**Recomendación:** **Opción A** para v1.1.0 (rápido). Si funciona, mantener. Migrar a B/C solo si se requiere narrative custom.

### D6 — ¿Validate corre en push a `main` también?

Hoy el CI corre en push a `main`. Con la separación validate/release:

- **validate.yml** → push a `feature/**` y `develop`, PR a `[develop, main]`.
- **release.yml** → push de tag `v*`.
- **¿Push directo a main sin tag?** Sí debería validar, no debería liberar.

**Recomendación:** validate.yml también dispara en `push: [main]` pero sin
deploy. Si alguien commitea directo en main (saltándose develop), igual
se valida. Tag `v*` separado es lo único que libera.

### D7 — ¿Qué pasa con los releases viejos?

GitHub conserva todos los releases con sus assets. Sin problema. Los
operadores siempre pueden descargar versiones anteriores → rollback
manual posible (descargar v1.0.9 y desplegar).

## Restricciones aplicables (recortado)

De la lista CNST original, en este scope SOLO aplican:

- **CNST-001 (NO email):** las notificaciones de release de GitHub
  llegan al webhook configurado o a la UI, no por email del sistema.
  ✅ Compatible.
- **CNST-005 (RBAC):** quien crea el tag `v*` es quien tiene permiso de
  push a main. GitHub branch protection ya garantiza esto vía PR
  approval. ✅ Compatible.
- **CNST-008 (entrega ZIP):** el `.tar.gz` ES el paquete versionado
  declarado en CNST_008. ✅ Cumple directamente.
- **CNST-009 (auditoría):** GitHub Releases mantiene registro inmutable
  de quién creó el tag, cuándo, qué commit. ✅ Compatible.

CNST que dejan de aplicar (estaban planteadas para staging/SSH/host
management que ya no están en scope): CNST-002 (sesiones), CNST-003
(BD IVR), CNST-004 (alertas), CNST-006 (rangos), CNST-007 (límites).

## Inventario reducido de cambios (post-scope)

### En el repo

- `.github/workflows/validate.yml` — reemplaza al actual `sphinx-build.yml` con `-W` strict, link checker, plantuml validator (~60 líneas)
- `.github/workflows/release.yml` — nuevo (~50 líneas)
- `source/normativa/procedimientos/PROC-OPS-001-deployment.rst` — procedimiento para la rotación: cómo descargar el release y desplegar (referencia operacional, no automatizada)
- `CHANGELOG.md` raíz — actualizado con sección `[1.1.0]` cuando se haga el primer release
- `pyproject.toml` — bump `version = "1.1.0"` cuando aplique

### Eliminado del scope original

- ❌ `.github/workflows/deploy-staging.yml`
- ❌ `.github/workflows/deploy-production.yml`
- ❌ `scripts/deploy.sh` y `scripts/health-check.sh`
- ❌ Configuración de servidores (Apache vhost, usuario `deploy`, SSH keys)
- ❌ Secrets en GitHub (`STAGING_SSH_KEY`, `PROD_SSH_KEY`, hosts, users)
- ❌ Environments (`staging`, `production` con manual approval)

### Pendiente de coordinación externa (post-WP)

- Rotación de operación: documentar quién descarga el release y cómo
  lo despliega (esto va en el PROC-OPS-001 como referencia, no como
  automatización del WP).

## Riesgos actualizados (subset del registro original)

Quedan vigentes:

- **R-01** (deploy contenido roto a producción) → Mitigado por
  `sphinx-build -W` en validate.yml + linkcheck. Si falla, no hay tag.
- **R-04** (SSH keys leakeadas) → Eliminado, no usamos SSH.
- **R-06** (eliminar build/ histórico antes del pipeline rompe acceso)
  → Sigue vigente: la limpieza histórica espera al primer release
  válido del nuevo pipeline.
- **R-07** (push a main sin validar dispara deploy) → Mitigado por
  separación: solo `tag v*` libera, push raw a main solo valida.
- **R-09** (ejecutor desconoce proceso manual actual) → Aceptado: está
  fuera del scope del WP entender o reemplazar el proceso post-release.

Eliminados por scope:

- ~~R-02~~ (backup pre-overwrite) — no overwriteamos nada
- ~~R-03~~ (health-check falla) — no hay health-check
- ~~R-05~~ (staging != prod) — no hay staging
- ~~R-08~~ (SSH SPOF) — no hay SSH
- ~~R-10~~ (sin Internet al on-premise) — no tocamos on-premise

## Próximo paso recomendado

**Phase 5 STRATEGY:** confirmar con el ejecutor las 7 decisiones D1-D7
arriba. Una vez aprobadas, ir directo a Phase 8 PLAN EXECUTION (no
necesitamos Phase 6 SCOPE separado porque el alcance ya está
clarísimo).

**Estimación de implementación (Phase 10):** ~2-3 horas para los 2
workflows + procedimiento RST + bump de versión + primer release de
prueba.
