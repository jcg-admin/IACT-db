```yml
created_at: 2026-04-30 09:06:01
project: IACT-docs
work_package: 2026-04-30-09-06-01-requisitos-update
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# DISCOVER — Análisis de `source/requisitos/`

## Resumen ejecutivo

`source/requisitos/` contiene **148 archivos `.rst`** organizados
en 5 categorías (BReq, BR, UC, FR, NFR). Cobertura desigual:
los 5 niveles de la jerarquía existen, pero **sólo el 18% de UCs
tiene FRs derivados** y hay **dos esquemas de naming en UCs
conviviendo** (con módulo y sin módulo) que producen una división
sistemática entre "UCs viejos" y "UCs nuevos".

## 1. Inventario por categoría

| Categoría | Archivos `.rst` | Estado |
|---|---|---|
| BReq (Business Requirements) | 2 (1 BReq + index) | Inicial — sólo BReq-001 |
| BR (Business Rules) | 21 (20 BRs + index) | Completo — BR_001..BR_020 sin gaps |
| UC (Use Cases) | 71 (61 UCs + 9 module index + 1 root index) | Cubierto — 9 módulos |
| FR (Functional Requirements) | 51 | Parcial — sólo 11 UCs tienen FRs |
| NFR (Non-Functional) | 3 (2 NFRs + index) | Embrionario |

## 2. Casos de Uso — distribución por módulo

| Módulo | UCs | UCs con FRs |
|---|---|---|
| access | 7 | 2 (uc-010, uc-011 — esquema numerado) |
| alerts | 5 | 0 |
| audit | 4 | 0 |
| auth | 5 | 5 (uc-001..uc-005 — esquema numerado) |
| logs | 7 | 0 |
| permissions | 10 | 0 |
| pipeline | 4 | 0 |
| reports | 15 | 0 |
| users | 4 | 4 (uc-006..uc-009 — esquema numerado) |
| **Total** | **61** | **11 (18%)** |

## 3. Hallazgo CRÍTICO — dos esquemas de naming en UCs

Coexisten dos convenciones para UCs en `casos-uso/`:

**Esquema A — numeración global (`uc-NNN-{desc}.rst`):**

```
casos-uso/auth/uc-001-iniciar-sesion.rst      ← sólo en auth, users, parte de access
casos-uso/users/uc-006-crear-usuario.rst
casos-uso/access/uc-010-asignar-funciones.rst
```

**Esquema B — módulo + numeración local (`uc-{MOD}-NN-{desc}.rst`):**

```
casos-uso/auth/uc-auth-01-iniciar-sesion.rst        ← duplicado semántico de uc-001
casos-uso/access/uc-acc-01-asignar-funciones.rst
casos-uso/permissions/uc-perm-01-asignar-grupo-a-usuario.rst
casos-uso/reports/uc-rpt-01-ver-dashboard.rst
casos-uso/alerts/uc-alr-01-configurar-umbrales.rst
casos-uso/audit/uc-aud-01-consultar-auditoria.rst
casos-uso/pipeline/uc-pip-01-supervisar-etl.rst
casos-uso/logs/uc-log-01-consultar-logs-sistema.rst
```

**Patrón observable:** los 11 UCs con FRs usan exclusivamente
esquema A (numerados puros). Los 50 UCs sin FRs usan exclusivamente
esquema B (con módulo). Es decir, los esquemas dividen los UCs en
dos generaciones: una "vieja" con FRs derivados y una "nueva" sin
FRs aún.

**STD-007 v2.0.2** declara como patrón canónico:
``uc-<MOD>-<NN>-<desc>.rst`` (esquema B). El esquema A es legacy.

**Implicación para la actualización:**

- Si el ejecutor actualiza UCs del esquema B, no toca a los FRs
  (no existen).
- Si el ejecutor actualiza UCs del esquema A, hay FRs derivados
  que deben sincronizarse.
- Si la actualización implica derivar nuevos FRs, conviene usar
  el esquema canónico B y reorganizar los FRs existentes para
  que apunten al UC con prefijo de módulo.

## 4. Cobertura UC → FR

```
UCs totales:    61
UCs con FRs:     11   (18%)
UCs sin FRs:    50   (82%)
```

**Módulos completos sin FRs:**

- `alerts` (5 UCs)
- `audit` (4 UCs)
- `logs` (7 UCs)
- `permissions` (10 UCs)
- `pipeline` (4 UCs)
- `reports` (15 UCs)

Total UC sin FR derivable: **45** (en estos 6 módulos) + **5** UCs
en access/permissions con esquema B sin pareja FR = **50**.

## 5. Cobertura BR → UC (existencia de derivación)

20 BRs presentes (`BR_001..BR_020`, sin gaps). Trazabilidad
declarada en BReq-001 (visibilidad-metricas → BR_016/017/018 +
UC_RPT_01..03).

No hay deep-review formal de cobertura BR → UC en este momento
(diferido al WP de actualización si el ejecutor lo solicita).

## 6. Business Requirements

Sólo 1 BReq:

- **BReq-001**: Visibilidad de Métricas Operativas

El cajón existe pero está embrionario. La actualización podría
incluir adición de más BReq.

## 7. NFRs

3 archivos:

- `index.rst`
- `rnf-proc-001-proceso-sdlc.rst`
- `rnf-proc-002-metricas-proceso.rst`

Sólo cubre módulo `proc`. Otros tipos de NFR (seguridad,
performance, disponibilidad) están reservados pero no creados —
ver
:doc:`/normativa/estandares/adr-std-007-spec-gaps-fix` § 4
(módulos `sec`, `perf`, `avail` declarados como reservados
futuros).

## 8. Inconsistencia interna del nombre de UCs en FRs

Los FRs viven en:

```
requisitos-funcionales/auth/uc-001-iniciar-sesion/fr-001-NN-...rst
requisitos-funcionales/users/uc-006-crear-usuario/fr-006-NN-...rst
requisitos-funcionales/access/uc-010-asignar-funciones/fr-010-NN-...rst
```

El directorio padre del FR usa esquema A (`uc-NNN-...`), pero el
UC canónico per STD-007 usa esquema B (`uc-{mod}-NN-...`). Esta
inconsistencia es la raíz del problema de actualización futura.

## 9. Observación — refs `:doc:` cross-jerarquía

Los UCs y FRs probablemente cross-referencian entre sí. Antes de
actualizar cualquier UC, conviene auditar las refs entrantes para
no romper la trazabilidad. Análisis diferido a Phase 3 ANALYZE
una vez que el ejecutor pase los cambios concretos.

## 10. Hallazgos accionables (para la actualización)

| ID | Hallazgo | Severidad | Acción sugerida |
|---|---|---|---|
| H-1 | Dos esquemas de UC coexisten | ALTO | Decidir si la actualización unifica al esquema B (canónico) o mantiene la coexistencia |
| H-2 | 50 UCs sin FRs derivados | ALTO | La actualización podría aprovechar para derivar FRs faltantes |
| H-3 | Sólo 1 BReq | MEDIO | Posible adición en la actualización |
| H-4 | NFRs cubren sólo `proc` | MEDIO | Posible adición en la actualización |
| H-5 | FR-dirs usan esquema A pero canónico es B | MEDIO | Si se unifica, requiere mover FR-dirs |

## 11. Pregunta abierta para el ejecutor

Antes de proseguir, necesito que el ejecutor pase:

1. **Lista concreta de cambios** a aplicar (qué requisitos
   actualizar / agregar / eliminar).
2. **Decisión sobre H-1** (¿unificar UCs al esquema B canónico
   en este WP, o tratar como out-of-scope?).
3. **Decisión sobre H-2** (¿derivar FRs faltantes en este WP,
   o limitar el WP a los cambios puntuales?).

## Trazabilidad

- **Skill aplicada:** `workflow-discover` (Phase 1 DISCOVER).
- **WP origen:** este (`2026-04-30-09-06-01-requisitos-update`).
- **Trabajo preparatorio:** move de `plantuml-guide` a
  `base-cognitiva/` (commit `2f9d2d4`).
