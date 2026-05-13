```yml
created_at: 2026-04-29 18:35:00
project: IACT-docs
work_package: 2026-04-29-17-52-15-modelo-rbac-improvement
phase: Phase 1 — DISCOVER (deep-review extension)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# RBAC Relations — Deep Review exhaustivo en source/

## Mea culpa metodológico

El análisis previo (`expected-content-spec.md`, `gap-analysis.md`)
solo consideró **1 ADR** (ADR-GOB-008) y **5 CNSTs** (029-033). Tras
auditar exhaustivamente con `grep -rln -iE "(rbac|grupos.*funcional|
permisos|capacidad|sod|menu.*dinamic)"`, la realidad es **mucho
mayor**. Este artefacto reemplaza al inventario incompleto y se debe
considerar la fuente autoritativa.

## Inventario completo de artefactos RBAC

### A. ADRs de RBAC (4 archivos, no 1)

| ID filename | Título interno | Estado | Fecha doc | Inconsistencia con modelo v5.2.1 |
|-------------|----------------|--------|-----------|-----------------------------------|
| **adr-back-001-grupos-funcionales-sin-jerarquia** | "ADR-005: Sistema de Permisos con Grupos Funcionales Sin Jerarquía" | aceptada | 2025-11-07 | Menciona **"19 funciones"** y **"130+ capacidades"** — divergente del modelo actual (42 funciones, 10 grupos AGR) |
| **adr-back-003-orm-sql-hybrid-permissions** | "ADR-010: Estrategia Híbrida ORM + SQL Nativo para Permisos" | aceptada | 2025-11-09 | Tiene **nota in-text "VALIDAR ESTA ESTRATEGIA"** — pendiente revisión |
| **adr-back-004-sistema-permisos-sin-roles-jerarquicos** | "ADR-012: Sistema de Permisos Granular SIN Roles Jerarquicos" | Aceptado | 2025-11-07 | Tiene **nota in-text "LA DEFINICION ESTA CORRECTA, SIN EMBARGO PARA UNA MAYOR TRAZABILIDAD SE REQUIERE QUE SE DOCUMENTE UNA MATRIZ RACI..."** — pendiente |
| **adr-gob-008-rbac-coexistencia-acc-perm** | "ADR-GOB-008: RBAC Coexistencia Vista Funcional ↔ Vista Técnica" | Aceptada | 2026-04-29 | El único alineado con v5.2.1; reconcilia las vistas. |

**Hallazgo:** los 3 ADR-BACK son **legacy** (de noviembre 2025) y no
fueron revisados al introducir el modelo v5.2.1 (enero 2026) ni
ADR-GOB-008 (abril 2026). Hay **drift de versionado conceptual** sin
ADR de superseding.

### B. CNSTs RBAC core (5)

| ID | Título | Versión | Vigente |
|----|--------|---------|---------|
| CNST-029 | RBAC Modelo Plano | 2.0.0 | ✓ |
| CNST-030 | Reglas SoD | 2.0.0 | ✓ |
| CNST-031 | Permisos Temporales Máx 6 Meses | 2.0.0 | ✓ |
| CNST-032 | Menú Dinámico Obligatorio | 1.0.0 | ✓ |
| CNST-033 | Vocabulario Unificado RBAC | 1.0.0 | ✓ |

### C. CNSTs RBAC-relacionados (5 más, no obvios)

| ID | Título | Relación con RBAC |
|----|--------|---------------------|
| CNST-007 | BD IVR es Solo Lectura | Restricción que limita qué funciones de modificación pueden definirse |
| CNST-010 | permission_classes Explícita en Vistas DRF | **Implementación enforcer del RBAC** en endpoints |
| CNST-025 | Auditoría Inmutable Append-Only | Subyace UC_ACC_09, UC_AUD_*, UC_PERM_09 |
| CNST-026 | PII Prohibida en Logs y Auditoría | Limita qué se audita en eventos RBAC |
| CNST-027 | Clasificación Obligatoria en 4 Niveles | Categoriza la sensibilidad — entrada para SoD |

### D. Casos de Uso RBAC (28 UCs en 4 dominios)

| Dominio | UCs | Tipo | Cobertura |
|---------|-----|------|-----------|
| **access** | UC_ACC_01..09 | Vista funcional (admin no-tech) | Asignar/revocar funciones, agrupadores, segmentos, SoD, permisos temporales, auditoría |
| **auth** | UC_AUTH_01..05 | Autenticación | Iniciar/cerrar sesión, recuperar/cambiar password, gestionar sesiones |
| **permissions** | UC_PERM_01..10 | Vista técnica (admin tech) | Asignar/revocar grupo, permisos excepcionales, crear grupos, capacidades, menú dinámico, auditar |
| **audit** | UC_AUD_01..04 | Auditoría transversal | Consultar/buscar/exportar auditoría, generar compliance |

### E. Reglas de Negocio RBAC (7 BRs)

| ID | Tema |
|----|------|
| BR-001 | Fuente Operacional Inmutable |
| BR-004 | Comunicaciones Internas Only |
| BR-006 | RBAC Flat NIST |
| BR-007 | Separación Funciones SoD |
| BR-010 | Auditoría Inmutable |
| BR-012 | Usuario-Segmento Único |
| BR-020 | Clasificación de Datos |

### F. Requisitos Funcionales (28 FRs en 5 UCs)

```
auth/uc-001-iniciar-sesion: 5 FRs
auth/uc-002-cerrar-sesion: 3 FRs
auth/uc-003-recuperar-password: 5 FRs
auth/uc-004-cambiar-password: 4 FRs
auth/uc-005-gestionar-sesiones: 4 FRs
access/uc-010-asignar-funciones: 4 FRs
access/uc-011-revocar-funciones: 3 FRs
```

### G. Metamodelos / Taxonomías / Ontología

| Artefacto | Rol |
|-----------|-----|
| **MTM-03 Metamodelo RBAC** | Modelo formal NIST Flat RBAC |
| TXM-01 Taxonomía Requisitos | Categoriza tipos (incluye "RBAC", "SoD") |
| TXM-03 Taxonomía Reglas Negocio | Incluye categoría "RBAC" |
| SBVR-01..05 Ontología | Vocabulario controlado (incluye terms RBAC) |
| **Glosario § H** | Vocabulario RBAC unificado canónico (8 términos) |

### H. Arquitectura Técnica

| Artefacto | Rol |
|-----------|-----|
| **modelo-rbac-iact.rst** | Modelo conceptual maestro (subject of this WP) |
| **arq-mod-003-rbac-core.rst** | Módulo arquitectónico "RBAC_CORE" — implementación |
| backend/conventions.rst | Guidelines backend (refiere modelo) |
| backend/overview.rst | Overview backend (incluye RBAC) |

### I. Plantillas que tocan RBAC

```
tpl-uc-casos-de-uso.rst       (UC template — incluye campo de permisos)
tpl-mod-modulos.rst           (módulo template — incluye RBAC integration)
tpl-api-documentacion-api.rst (API template — incluye permission_class)
tpl-breq-objetivos-negocio.rst (incluye traceability a CNSTs RBAC)
```

### J. Procedimientos que tocan RBAC

```
proc-doc-004-generacion-mod    (cómo generar módulos con RBAC)
proc-doc-006-generacion-view   (incluye permission_class)
proc-req-005..011              (derivación BR→UC→FR — incluye RBAC examples)
```

## Mapa de relaciones

```
                              ADR-GOB-008 (2026-04-29)
                                    │
                         reconcilia las 2 vistas
                                    │
                ┌───────────────────┴────────────────────┐
                │                                          │
        Vista funcional                         Vista técnica
       (modelo v5.2.1)                          (PERM granular)
                │                                          │
       MOD_Access (UC_ACC_01..09)              MOD_Permissions (UC_PERM_01..10)
                │                                          │
                └──────────┬─────────────┬──────────────────┘
                           │             │
                  modelo-rbac-iact   arq-mod-003-rbac-core
                  (conceptual)       (implementación)
                           │             │
                           └──┬──────────┘
                              │
                        rige sobre:
                              │
        ┌─────────────────┬───┴───┬───────────────┬────────┐
        │                 │       │               │        │
   CNST-029 (Plano)  CNST-030  CNST-031     CNST-032   CNST-033
                     (SoD)     (Tempo 6m)   (Menu din) (Vocab)
        │                 │       │               │        │
        └─────────────────┼───────┼───────────────┼────────┘
                          │       │               │
                          └───────┼───────────────┘
                                  │
                          BR-006 (Flat NIST)
                          BR-007 (SoD)
                          BR-012 (Segmento único)
                          BR-020 (Clasif datos)
                                  │
                          MTM-03 (Metamodelo NIST)
                          Glosario § H (Vocab)
                          SBVR (Ontología)
```

## Inconsistencias detectadas (drift de información)

### Inc-01 MAJOR — Cifras divergentes ADR vs modelo

- **ADR-BACK-001** (nov 2025): "**19 funciones**" + "**130+ capacidades**".
- **modelo-rbac-iact** (v5.2.1): **42 funciones** + 10 grupos AGR.
- **ADR-GOB-008** (abr 2026): canoniza 42 funciones + 10 AGR.

ADR-BACK-001 NUNCA fue revisado tras introducir v5.2.1 ni ADR-GOB-008.
**Necesita superseding o update**.

### Inc-02 MAJOR — Vocabulario divergente entre ADRs

- **ADR-BACK-001/003/004** usan "**Capacidad**" (D-RBAC-1 deprecó este término).
- **CNST-033** mandata "**Función**" canonical (Capacidad PROHIBIDA).
- **ADR-GOB-008** declara la migración Capacidad → Function (D-RBAC-8).

Los 3 ADR-BACK violan **CNST-033** sin haber sido superseded.

### Inc-03 MAJOR — Notas in-text de "pendiente"

- **ADR-BACK-003**: "NOTA: VALIDAR ESTA ESTRATEGIA YA QUE ES REDUDANTE..."
- **ADR-BACK-004**: "LA DEFINICION ESTA CORRECTA, SIN EMBARGO PARA UNA
  MAYOR TRAZABILIDAD SE REQUIERE QUE SE DOCUMENTE UNA MATRIZ RACI..."

ADRs son inmutables tras aceptación (STD del proyecto). Estas notas
indican que las decisiones requieren revisión formal — no son ADRs
limpios.

### Inc-04 MAJOR — Modelo conceptual + módulo arquitectónico cubren lo mismo

- **modelo-rbac-iact.rst** (2558 líneas): conceptual + implementación.
- **arq-mod-003-rbac-core.rst** (~400 líneas): "Módulo Arquitectónico" con
  RBAC_CORE — también describe el sistema RBAC.

**Dos artefactos del mismo dominio sin clear ownership.** El modelo
v5.2.1 tiene 39% código, ARQ_MOD_003 tiene la arquitectura del módulo.
**Hay duplicación + posible drift.**

### Inc-05 MAJOR — Refs entrantes del modelo NO incluyen los ADR-BACK

Los 3 ADR-BACK NO referencian al modelo `modelo-rbac-iact.rst`.
ADR-GOB-008 sí lo referencia. **Falta bidireccionalidad de trazabilidad.**

### Inc-06 INFO — Glosario § H ya canoniza la versión correcta

`base-cognitiva/glosario.rst` § H "Vocabulario RBAC unificado" usa
correctamente "Función" canónico y referencia ADR-GOB-008. **OK.**

## Recalibración del scope del WP

El WP previo (modelo-rbac-improvement) asumía mejorar SOLO
`modelo-rbac-iact.rst`. Tras este deep-review, el scope **realista**
es uno de tres:

| Opción | Scope | Costo | Beneficio |
|--------|-------|-------|-----------|
| **X — Solo modelo (lo planeado)** | Mejorar modelo-rbac-iact.rst con findings F-01..F-21 del gap analysis previo | Medio (4-6h) | Modelo coherente pero ADR-BACK siguen drift |
| **Y — Modelo + ADR-BACK supersede** | X + supersede formal de ADR-BACK-001/003/004 con ADRs nuevos alineados a v5.2.1 + ADR-GOB-008 | Alto (1-2 sesiones) | Resuelve Inc-01, Inc-02, Inc-03 |
| **Z — Reorganización completa RBAC** | Y + reconciliar modelo conceptual ↔ ARQ_MOD_003 (Inc-04) + agregar refs bidireccionales (Inc-05) | Crítico (3-4 sesiones) | Single source of truth completo |

## Recomendación revisada

**Opción Y como mínimo** — sin abordar los ADR-BACK legacy que violan
CNST-033 vigente, mejorar el modelo-rbac-iact es **insuficiente para
alcanzar consistencia normativa**.

**Opción Z** sería la correcta pero amerita ROADMAP propio. Z
materializa el "WP #7 (pendiente)" mencionado en ADR-GOB-008 §"Implementación".

## Calibración

- **OBSERVABLE:** 41 claims (verificados con grep + Read sobre todos los archivos listados).
- **INFERRED:** 9 claims (interpretación de drift entre artefactos).
- **SPECULATIVE:** 0.
- **Ratio (OBS+INF)/total:** 50/50 = 1.0 ≥ 0.75 ✓

## Decisión pendiente del ejecutor

Antes de Phase 5 STRATEGY, decidir:

1. **Scope del WP** — X / Y / Z / mix.
2. **Si Y o Z:** ¿abrir mini-WPs separados para los ADR-BACK legacy
   (1 WP por ADR a supersede) o unificar en un mega-WP?
3. **Confirmar:** los 707 IDs canónicos (MOD_*, AGR-*, SOD-*,
   funciones) son inmutables — ✓ esperado.
