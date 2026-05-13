```yml
created_at: 2026-04-29 19:00:00
project: IACT-docs
work_package: 2026-04-29-17-52-15-modelo-rbac-improvement
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador (decisión pendiente del ejecutor)
version: 1.0.0
```

# Z Monolítico vs Z Particionado — Análisis comparativo

## Contexto

El ejecutor confirmó que el objetivo del WP es **"garantizar
implementabilidad correcta"** del subsistema RBAC futuro. Las 5
inconsistencias detectadas en el deep-review (Inc-01..Inc-05) son
CRITICAL bajo este framing porque inducen implementación divergente.

La opción Z (refactor completo) es el mínimo correcto. Queda la
decisión:

- **Z monolítico:** un solo WP grande que aborda todas las
  inconsistencias en secuencia interna.
- **Z particionado (Z.1..Z.5):** 5 sub-WPs encadenados, cada uno
  con su ciclo THYROX completo y commits agrupados.

Este documento compara ambos para informar la decisión.

## Definición precisa de cada modo

### Modo A — Z Monolítico

Un solo WP con identifier
`2026-04-29-17-52-15-modelo-rbac-improvement` (este WP).

```
Phase 1 DISCOVER  ── completado (este WP)
Phase 5 STRATEGY  ── decisión técnica para los 5 frentes
Phase 6 PLAN      ── scope unificado
Phase 8 PLAN-EXEC ── task plan T-001..T-NN cubriendo TODO Z
Phase 9 PILOT     ── valida el primer cambio (típicamente Z.1
                     piece como prueba)
Phase 10 EXECUTE  ── ejecuta TODO el task plan
Phase 11 TRACK    ── un solo changelog
Phase 12 STANDARDIZE ── un cierre
```

**Commits:** muchos commits Tim Pope agrupados temáticamente, todos
en este WP. Commit messages refieren a "Z.X" como sub-bloque pero
NO hay separación formal de WP.

**Cierre:** un solo cierre formal con un changelog consolidado.

### Modo B — Z Particionado (Z.1..Z.5)

5 WPs encadenados, cada uno con timestamp propio:

```
Z.1: 2026-04-29-NN-NN-NN-rbac-adr-superseding
     Aborda Inc-01, Inc-02, Inc-03 (ADR-BACK legacy)
     Output: 1-3 ADRs nuevos que supersede ADR-BACK-001/003/004

Z.2: 2026-04-30-NN-NN-NN-rbac-modelo-conceptual-cleanup
     Aborda F-01..F-21 del gap analysis del modelo
     Output: modelo-rbac-iact alineado, código etiquetado como
             "Reference design"

Z.3: 2026-05-NN-NN-NN-NN-rbac-arq-mod-003-reconciliation
     Aborda Inc-04 (ownership entre modelo y ARQ_MOD_003)
     Output: clear ownership documented

Z.4: 2026-05-NN-NN-NN-NN-rbac-bidirectional-traceability
     Aborda Inc-05 (cross-refs)
     Output: refs bidireccionales en todo el corpus RBAC

Z.5: 2026-05-NN-NN-NN-NN-rbac-final-adversarial-validation
     Deep-review final
     Output: confirmación SSO Truth + closure
```

Cada WP ejecuta su ciclo THYROX completo (DISCOVER simplificado
heredando de este WP, STRATEGY, PLAN, EXECUTE, TRACK).

**Commits:** agrupados por sub-WP con timestamp distinto.

**Cierre:** 5 cierres formales encadenados.

## Comparación detallada

### Eje 1 — Tiempo de ejecución total

| Modo | Estimado |
|------|---------:|
| **A monolítico** | 3-4 sesiones (sin overhead de re-onboarding entre WPs) |
| **B particionado** | 4-5 sesiones (overhead ~20% por re-discover y closure repetidos) |

**Ganador:** A (más eficiente en wallclock).

### Eje 2 — Riesgo de regresión / cascading break

| Eje | A monolítico | B particionado |
|-----|--------------|----------------|
| Cambios en flight simultáneos | ALTO (múltiples frentes abiertos) | BAJO (1 frente a la vez) |
| Build verde tras cada commit | Sí (política I-015) | Sí (mejor rollback granular) |
| Rollback parcial si algo se rompe | Difícil (commits entremezclados) | Trivial (revertir el sub-WP completo) |
| Detección temprana de bugs | Más tarde (al final del WP) | Más temprano (al cierre de cada Z.N) |

**Ganador:** B (rollback granular y detección temprana).

### Eje 3 — Carga cognitiva del ejecutor (revisar diffs)

| Modo | Diff medio por revisión |
|------|------------------------|
| A | Grande — el WP final tendrá 30-50+ commits, ~80-150 archivos tocados |
| B | Pequeño — cada Z.N cierra con 5-15 commits, ~10-30 archivos |

**Ganador:** B (revisión digerible por el ejecutor).

### Eje 4 — Independencia entre frentes

| Frente | Independiente? | Bloquea otros? |
|--------|----------------|----------------|
| Z.1 ADR superseding | **Sí** — autocontiene | Sí, bloquea Z.2/Z.3 (cualquier cambio al modelo o ARQ_MOD debe alinearse a los ADRs nuevos) |
| Z.2 Modelo conceptual cleanup | Parcial — depende de Z.1 (vocabulario "Función") | Bloquea Z.3 |
| Z.3 modelo ↔ ARQ_MOD_003 reconciliation | Depende de Z.1 + Z.2 | Bloquea Z.4 |
| Z.4 Bidirectional traceability | Depende de Z.1+Z.2+Z.3 (tienen refs estables) | Bloquea Z.5 |
| Z.5 Adversarial validation | Depende de TODOS | No bloquea (es validación) |

Hay **dependencia secuencial estricta** Z.1 → Z.2 → Z.3 → Z.4 → Z.5.
NO se pueden paralelizar.

**Implicación:** B no aprovecha paralelismo (no hay). Pero respeta
la dependencia natural.

### Eje 5 — Trazabilidad y auditabilidad

| Aspecto | A | B |
|---------|---|---|
| Mensaje de commit hace explícito Z.N | Sí (texto) | Sí (texto + WP timestamp) |
| Audit trail por sub-frente | Difuso | Claro (1 WP = 1 frente) |
| Cierre de WP como milestone | 1 milestone grande | 5 milestones |
| Status report a stakeholders | Difícil ("estamos en Z.N de un WP gigante") | Fácil ("Z.1 cerrado, Z.2 en curso") |

**Ganador:** B (audit trail más legible).

### Eje 6 — Alineación con metodología THYROX

| Modo | Alineación |
|------|-----------|
| A | THYROX permite WPs de cualquier tamaño. No hay regla que prohíba un WP grande con multi-frente. PERO el patrón típico es "1 WP = 1 problema bien definido". |
| B | Encaja perfecto con "1 WP = 1 problema". Cada Z.N tiene su exit criteria, gate, y cierre formal. Es el patrón canónico THYROX. |

**Ganador:** B (más idiomático).

### Eje 7 — Posibilidad de pausar / cambiar de prioridad

| Escenario | A | B |
|-----------|---|---|
| Pausar a media obra | Doloroso (WP queda en estado inconsistente, los frentes parciales se entremezclan) | Natural (entre Z.N y Z.N+1, todo está commited y verde) |
| Reordenar sub-frentes (ej. Z.4 antes de Z.3) | Requiere replanning interno del WP | Trivial (re-numerar timestamps) |
| Abortar y retomar después | Difícil | Fácil (cada Z.N es self-contained) |

**Ganador:** B (resiliente a interrupciones).

### Eje 8 — Costo de overhead (re-discover, re-closure)

| Modo | Overhead |
|------|---------:|
| A | 1 DISCOVER + 1 STRATEGY + 1 PLAN + 1 PLAN-EXEC + 1 TRACK + 1 STANDARDIZE = 6 fases overhead |
| B | 5 × (DISCOVER mínimo + STRATEGY + PLAN + PLAN-EXEC + TRACK) = ~20-25 fases overhead |

**Ganador:** A (4-5x menos overhead documental).

**Mitigación de B:** los sub-WPs de un mismo programa pueden
compartir el DISCOVER (referenciando este WP padre) y los STANDARDIZE
pueden ser livianos. Reduce overhead a ~15 fases.

### Eje 9 — Riesgo de "abandono parcial"

| Modo | Riesgo |
|------|--------|
| A | Si abandono el WP a mitad: corpus en estado inconsistente. Rollback completo pierde todo. |
| B | Si abandono después de Z.2 cerrado: Z.1+Z.2 son value entregado. Z.3+ pueden retomarse o no. |

**Ganador crítico:** B (resiliente al abandono parcial).

## Tabla resumen — score por eje

| Eje | A monolítico | B particionado |
|-----|:-------------:|:---------------:|
| 1. Tiempo total | ✅ | ⚠️ |
| 2. Riesgo regresión / rollback | ⚠️ | ✅ |
| 3. Carga cognitiva revisión | ⚠️ | ✅ |
| 4. Independencia entre frentes | = | = |
| 5. Trazabilidad auditable | ⚠️ | ✅ |
| 6. Alineación THYROX | ⚠️ | ✅ |
| 7. Pausabilidad / reordenable | ⚠️ | ✅ |
| 8. Overhead documental | ✅ | ⚠️ |
| 9. Resiliencia abandono parcial | ❌ | ✅ |

**B gana 6 ejes, A gana 2 ejes, 1 empate.**

## Cuándo elegir A (monolítico)

A es preferible si:

- **Tiempo total es la métrica crítica** (presión de timeline para
  iniciar implementación).
- **Hay alta confianza** de que ningún sub-frente va a requerir
  pivoteo o cambio de plan.
- **El ejecutor revisa al final**, no commit-by-commit.
- **No se prevé pausar** el WP por otras prioridades.

## Cuándo elegir B (particionado)

B es preferible si:

- **Auditabilidad es crítica** (trazabilidad granular requerida).
- **Hay incertidumbre** sobre el plan de los sub-frentes
  posteriores (especialmente Z.3 reconciliación arquitectónica).
- **Se valora rollback granular** ante errores.
- **Se prevé interrupciones** o cambios de prioridad.
- **El proyecto es production-track** con stakeholders externos
  que ven progreso milestone-by-milestone.

## Recomendación con justificación

**Recomiendo Modo B (Z particionado) por estas razones específicas
del proyecto IACT:**

1. **El framing de "garantizar implementabilidad correcta"** es alto-
   stakes — un error en el corpus RBAC induce sistema implementado
   incorrectamente. **Rollback granular reduce el blast radius**
   de cualquier error de spec en este WP.

2. **Z.3 (reconciliación modelo ↔ ARQ_MOD_003) tiene la mayor
   incertidumbre** — el camino correcto NO está claro hoy (¿
   consolidar? ¿clear ownership con ambos vivos?). En modo A esa
   incertidumbre se mete dentro de un WP grande. En modo B, Z.3
   queda como WP propio con su propio DISCOVER que aclara la
   pregunta.

3. **Z.1 es la prioridad máxima** (ADR-BACK contradicen v5.2.1).
   En modo B, Z.1 puede ejecutarse YA y dejar el corpus
   "implementable-safe" en su capa normativa, mientras Z.2..Z.5
   siguen su ritmo. En modo A todo Z.1 queda escondido dentro
   del WP gigante hasta que el WP cierre.

4. **THYROX está diseñado para este patrón**. La metodología tiene
   "ÉPICA" para programas multi-WP. El proyecto IACT ya tiene
   precedente: WPs serializados (#7 backend, #8 backend cerrado,
   #9 frontend, etc.).

**El precio del modo B (~20% más overhead documental) se paga con
creces en los 6 ejes que gana.**

## Modo híbrido (sugerencia adicional)

Existe un tercer camino: **Z.1 como WP independiente PRIMERO + el
resto Z.2-Z.5 como un solo WP**. Razones:

- Z.1 aborda los ADR-BACK legacy que **violan CNST-033 vigente AHORA**.
  Es deuda normativa activa, no solo prep para implementación. Cerrarlo
  rápido tiene valor independiente.
- Z.2-Z.5 son prep pre-implementación; pueden agruparse si se trata
  como un solo programa.

| Modo | Tiempo | Riesgo | Trazabilidad |
|------|--------|--------|--------------|
| A | mejor | peor | peor |
| B | peor | mejor | mejor |
| **Híbrido** | medio | mejor (para Z.1) + medio | mejor (para Z.1) + medio |

## Decisión pendiente

El ejecutor decide entre:

- **A** (monolítico) — eficiencia
- **B** (particionado) — resilencia / auditabilidad
- **Híbrido** — pragmático

Una vez decidido, el WP avanza a Phase 5 STRATEGY con el modo
seleccionado.
