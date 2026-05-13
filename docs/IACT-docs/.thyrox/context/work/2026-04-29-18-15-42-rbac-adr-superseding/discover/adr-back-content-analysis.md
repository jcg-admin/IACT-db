```yml
created_at: 2026-04-29 19:35:00
project: IACT-docs
work_package: 2026-04-29-18-15-42-rbac-adr-superseding
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# ADR-BACK-001/003/004 — Análisis de contenido

## Calibración

- **OBSERVABLE:** 36 claims (lectura directa de los 3 ADRs).
- **INFERRED:** 4 claims (interpretación del overlap conceptual).
- **SPECULATIVE:** 0.
- **Ratio:** 40/40 = 1.0 ≥ 0.75 ✓

## Resumen ejecutivo de cada ADR

### ADR-BACK-001 — Grupos Funcionales Sin Jerarquía

| Aspecto | Valor |
|---------|-------|
| Líneas | 408 |
| Fecha | 2025-11-07 |
| Estado actual | aceptada |
| Decisión central | Adoptar "Grupos Funcionales Sin Jerarquía" en lugar de RBAC tradicional o ABAC |
| Cifras citadas | **19 funciones (recursos)**, **130+ capacidades**, **17+ grupos descriptivos**, 8 tablas BD, 11 semanas implementación |
| Vocabulario | "Funciones", "**Capacidades**", "Grupos", "Usuarios" |
| Plan implementación | 5 fases, 11 semanas (Nov 2025 — Feb 2026) |
| Métricas validación | < 50ms p95, 80%+ usuarios con grupos únicos, encuesta > 4/5 |

**Núcleo de la decisión:** rechazar RBAC jerárquico (con etiquetas tipo
Admin/Supervisor) y rechazar ABAC (demasiado complejo). Adoptar
sistema plano donde un usuario puede pertenecer a N grupos
descriptivos, cada grupo agrupa capacidades atómicas.

**Ejemplos de grupos en ADR-BACK-001:** `atencion_cliente`,
`gestion_equipos`, `analisis_operativo`, `auditoria_llamadas`,
`gestion_pagos`.

### ADR-BACK-003 — ORM + SQL Híbrido para Permisos

| Aspecto | Valor |
|---------|-------|
| Líneas | 485 |
| Fecha | 2025-11-09 |
| Estado actual | aceptada (con nota in-text) |
| Decisión central | Usar estrategia híbrida: ORM Django para CRUD + Vistas SQL para queries frecuentes + Funciones SQL para verificaciones ultra-rápidas |
| Cifras citadas | 100-1000 req/s esperados, 100-500 usuarios concurrentes, 8 tablas + vistas, 5-10ms verificación SQL vs 30-50ms ORM |
| Vocabulario | "**Capacidad**", "**capacidades_grupos**", "vista_capacidades_usuario" |
| Tech específico | PostgreSQL stored procedures, Django ORM, vistas materializadas |

**Núcleo de la decisión:** decisión de implementación técnica para
performance. NO redefine el modelo conceptual — opera sobre el
modelo definido en ADR-BACK-001/004.

**Funciones SQL declaradas como completas:**
- `usuario_tiene_permiso()`
- `obtener_capacidades_usuario()`
- `obtener_grupos_usuario()`
- `verificar_permiso_y_auditar()`
- `obtener_menu_usuario()` ← **alineado con CNST-032 menú dinámico**

### ADR-BACK-004 — Sistema de Permisos Granular SIN Roles Jerárquicos

| Aspecto | Valor |
|---------|-------|
| Líneas | 435 |
| Fecha | 2025-11-07 (mismo día que ADR-BACK-001) |
| Estado actual | Aceptado (con nota in-text) |
| Decisión central | Implementar permisos granulares basados en capacidades, sin roles jerárquicos |
| Vocabulario | "**Capacidades**", "Grupos de Permisos", "Usuario" |
| Solapamiento | **Significante con ADR-BACK-001** — ambos rechazan jerarquías y proponen grupos. ADR-BACK-004 es más conceptual; ADR-BACK-001 más implementacional. |

**Núcleo de la decisión:** principio de "sin etiquetas jerárquicas".
Define la jerarquía de entidades:

```
USUARIO → GRUPOS DE PERMISOS (multiples) → CAPACIDADES (atómicos) → FUNCIONES (recursos)
```

## Análisis de overlap

### ADR-BACK-001 vs ADR-BACK-004

Ambos ADRs **abordan el mismo problema** y llegan a **la misma
decisión** con vocabulario casi idéntico. Diferencias menores:

| Aspecto | ADR-BACK-001 | ADR-BACK-004 |
|---------|--------------|---------------|
| Foco | Comparación de 3 opciones (RBAC/ABAC/Híbrido) | Justificación filosófica del rechazo de roles |
| Cifras concretas | 19 funciones + 130 capacidades + 17 grupos | (sin cifras) |
| Plan implementación | 5 fases en 11 semanas | (no incluye plan) |
| Tono | Técnico-decisional | Filosófico-justificativo |

**Conclusión:** son **ADRs duplicados / redundantes**. ADR-BACK-004
es esencialmente la "introducción filosófica" que ADR-BACK-001
incorpora en su sección "Contexto y Problema".

### ADR-BACK-003 vs ADR-BACK-001/004

ADR-BACK-003 **NO duplica** a los otros dos — opera en una capa
diferente (implementación técnica) sobre el modelo que ellos
definen. Es complementario.

## Mapeo a v5.2.1 / CNST-033 / ADR-GOB-008

### Conceptos preservables (recoverable)

| Concepto del legacy | Mapeo a vigente |
|---------------------|------------------|
| "Grupos Funcionales sin jerarquía" | ✓ Sigue válido (los AGR-001..010 implementan esto) |
| "Sin etiquetas jerárquicas" (Admin/Supervisor) | ✓ Sigue válido (filosofía "Sin Pretensiones" v5.2.1) |
| "Usuario tiene N grupos simultáneamente" | ✓ Sigue válido (cardinalidad N:M) |
| "Funciones (recursos)" | ⚠️ Cambia semántica: en v5.2.1 "Función" = capacidad atómica, NO recurso |
| Estrategia ORM + SQL híbrida | ✓ Sigue válido (CNST-032 requiere `obtener_menu_usuario` SQL) |
| Performance < 50ms p95 | ✓ Métrica reusable |

### Conceptos a corregir (deprecados)

| Concepto del legacy | Razón | Reemplazo |
|---------------------|-------|-----------|
| **"Capacidad"** (todos los ADRs) | CNST-033 vigente PROHIBE el término | "Función" / "Function" (canónico) |
| **"19 funciones"** (ADR-BACK-001) | v5.2.1 declara 8 módulos × promedio 5 funciones = 42 funciones atómicas | "42 funciones distribuidas en 8 módulos" |
| **"130+ capacidades"** (ADR-BACK-001) | Se confunde el concepto: lo que hoy son "funciones" eran "capacidades" en el legacy | "42 funciones" |
| **"17+ grupos descriptivos"** (ADR-BACK-001) | v5.2.1 declara 10 grupos predefinidos + custom creables | "10 grupos AGR-001..010 + custom creables (D-RBAC-4)" |
| **"Función = recurso"** (ADR-BACK-001) | v5.2.1 redefine: Función = capacidad atómica, no recurso | **Recursos = "Módulos"** (8 MOD: Auth, Users, Access, Pipeline, Reports, Alerts, Audit, Logs) |
| Plan de implementación 5 fases (Nov 2025-Feb 2026) | Plan no ejecutado; corpus actual NO está implementado | Eliminar (o marcar como histórico) |

### Conceptos a agregar (faltan en los legacy)

| Concepto v5.2.1 / CNST / ADR-GOB-008 | Faltante en legacy |
|---------------------------------------|---------------------|
| 3 reglas SoD declaradas (SOD-001/002/003) | NO mencionadas en ningún ADR-BACK |
| Permisos temporales máximo 6 meses (CNST-031) | NO mencionados |
| Vocabulario unificado canónico (CNST-033) | NO existía en 2025 |
| Coexistencia ACC ↔ PERM (ADR-GOB-008) | NO mencionada |
| Distinción system vs custom groups (D-RBAC-4) | Implícita en "17+ grupos" pero no formalizada |
| Auditoría inmutable append-only (CNST-025) | Mencionada solo tangencialmente |

## Estructura propuesta para los ADRs nuevos

### Opción A — 1 ADR nuevo que supersede los 3

**Pros:** consolidación clara, single source of truth para la
decisión RBAC.
**Contras:** ADR muy grande (probable 500-700 líneas); pierde la
granularidad de "qué decisión exacta supersede cada legacy".

### Opción B — 3 ADRs nuevos (uno por cada legacy)

**Pros:** trazabilidad 1-a-1 con los legacy; cada nuevo aborda un
sub-problema específico.
**Contras:** crea 3 nuevos ADRs cuando 2 de los 3 legacy
(BACK-001 + BACK-004) son redundantes — duplicaríamos la
redundancia.

### Opción C — 2 ADRs nuevos: 1 conceptual + 1 técnico

**Pros:** ADR conceptual supersede BACK-001 + BACK-004 (que son
redundantes); ADR técnico supersede BACK-003 (capa distinta).
Refleja el análisis real de overlap.
**Contras:** requiere decidir nombre/ubicación de los 2 nuevos.

**Recomendada:** Opción C.

## Propuesta concreta de ADRs nuevos (Opción C)

### ADR nuevo 1: `adr-gob-009-rbac-modelo-conceptual.rst`

- Supersede ADR-BACK-001 + ADR-BACK-004 (decisiones conceptuales).
- Alineado a v5.2.1 cifras (42 funciones / 10 grupos AGR / 3 SoD).
- Vocabulario canónico (CNST-033).
- Cross-refs: modelo + CNST-029/030/031/032/033 + ADR-GOB-008.

### ADR nuevo 2: `adr-back-005-rbac-estrategia-implementacion.rst`

- Supersede ADR-BACK-003 (decisión técnica de implementación).
- Mantiene la estrategia híbrida ORM + SQL.
- Alinea funciones SQL al vocabulario canónico (`usuario_tiene_funcion`
  no `usuario_tiene_capacidad`, etc.).
- Cross-refs: ADR nuevo 1 + CNST-032 menú dinámico + ADR-BACK-003 (legacy).

**Por qué `adr-gob-NNN` para el conceptual y `adr-back-NNN` para el
técnico:**
- El conceptual (cómo modelar RBAC sin jerarquía) es decisión de
  GOBERNANZA arquitectónica, transversal a backend/frontend.
- El técnico (ORM + SQL) es específico de BACKEND.

Esto sigue la convención de los módulos `adr-back-*`, `adr-front-*`,
`adr-gob-*` documentada en STD-007 v2.0.2 §4.

## Próximo paso

T-002: triagear las 2 notas in-text de ADR-BACK-003 y ADR-BACK-004
para decidir si su contenido va integrado en los nuevos ADRs o
se descarta.
