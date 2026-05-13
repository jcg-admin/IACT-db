```yml
project: IACT-docs
work_package: 2026-05-01-05-17-20-uc-dependency-matrix-iact
created_at: 2026-05-01 05:17:20
current_phase: Phase 11 — TRACK (closed)
closed_at: 2026-05-01 06:30:00
status: Cerrado v1.0.0 — 6 partes + conclusión + lessons-learned
author: NestorMonroy
flow: rm
methodology_step: cerrado
predecessor_wp: 2026-05-01-03-29-03-uc-corrections-against-canonical-model
```

# WP — Matriz de dependencias UC × UC del catálogo IACT

## Propósito

Producir una **MATRIZ-DEPENDENCIAS** completa y
profesional sobre los 61 UCs vigentes del catálogo
IACT, con clasificación por criticidad, flujo
crítico identificado, dependencias intra-cluster
y cross-cluster, y visualizaciones PlantUML.

La metodología es la propuesta por el ejecutor
(2026-05-01) — ejemplo orientativo del dominio
ecommerce — adaptada al dominio real IACT.

## Origen

Trabajo derivado del cierre del WP previo
``2026-05-01-03-29-03-uc-corrections-against-canonical-model``.
Con el modelo de dominio canonizado (25 clases),
los 61 UCs alineados al modelo y la trazabilidad
``Clase de Dominio`` + ``UC Relacionados``
saneada, ahora se puede construir un análisis
formal de dependencias sin riesgo de heredar
ambigüedades del corpus.

## Adaptación de la metodología al dominio IACT

El ejemplo orientativo del ejecutor venía del
dominio ecommerce (Login → Catálogo → Carrito →
Orden → Pago). El dominio IACT es distinto:

- **Producto:** call center IVR + analytics +
  RBAC granular + supervisión ETL + auditoría.
- **Flujo crítico canónico:** sesión autenticada
  → verificación de permiso → operación del
  cluster (RPT / PIP / ALR / AUD / etc.).
- **Universalidad:** UC_AUTH_01 (Iniciar Sesion)
  + UC_PERM_07 (Verificar Permiso) son
  pre-requisitos transversales de prácticamente
  todos los UCs operativos.
- **Auditoría como sumidero:** todas las
  operaciones de escritura emiten AuditEvent
  (CNST-025), consumido por UC_AUD_01..04.

La matriz se construirá con esos ejes — no con
los del ejemplo ecommerce.

## Scope

### IN

- Clasificación de los **61 UCs vigentes** por
  criticidad (CRÍTICOS / ALTOS / MEDIOS / BAJOS).
- **Flujo crítico mínimo** del sistema (camino
  end-to-end más corto sin el cual el sistema no
  cumple su propósito).
- **Matriz UC × UC** — para cada UC: dependencias
  entrantes (qué UCs lo invocan / requieren) y
  salientes (a qué UCs invoca / requiere).
- **Dependencias transversales** — Auth,
  Permission check, AuditEvent emission, ETL
  upstream.
- **Análisis intra-cluster** y **cross-cluster**.
- **Camino crítico** (longest path) y
  identificación de cuellos de botella.
- **Implicaciones operativas** — orden de
  implementación, testing y rollout.
- **Visualizaciones PlantUML** — overview +
  por cluster + camino crítico.

### OUT

- Especificación detallada de UCs individuales
  (cada UC ya tiene su .rst).
- Modificaciones al modelo de dominio canónico
  (cerrado en WP previo).
- Cambios a los UCs (cerrado en WP previo).
- Estimación de esfuerzo / costos / personas
  reales (out de scope analítico — solo
  trazabilidad estructural).

## Insumos

- ``source/requisitos/casos-uso/`` — los 61 UCs
  vigentes con su trazabilidad saneada.
- ``source/arquitectura-tecnica/modelo-dominio-iact.rst``
  v1.0.0 — 25 clases en 7 bounded contexts.
- ``source/arquitectura-tecnica/rbac/modelo-rbac-iact.rst``
  v5.4.0 — 61 funciones RBAC.
- ADR-GOB-008 — coexistencia ACC ↔ PERM.
- WP previo ``uc-corrections``
  ``analyze/decisions-log.md`` — para entender
  qué UCs son Cat 1..5 (Z.2.A).

## Estructura del entregable (6 partes + conclusión)

Reestructurado al template visto en el segundo
ejemplo del ejecutor (matriz-dependencias estilo
analítico denso):

1. **Parte 1** — Resumen ejecutivo: distribución
   por criticidad + flujo crítico + dependencias
   transversales + densidad del grafo. (HECHO en
   ``parte-01-resumen-ejecutivo.md``.)
2. **Parte 2** — Tabla maestra: los 61 UCs con
   ficha por UC (Criticidad, Complejidad
   estimada, Actor, INCLUYE, EXTIENDE, Patrones,
   Clase de Dominio, Función RBAC, Dependencias)
   organizada por los 9 clusters.
3. **Parte 3** — Matriz de dependencias en
   formato compacto: una línea por UC con
   ``UC_ID → INCLUYE [...] → EXTIENDE [...] →
   REQUIERE [...]``.
4. **Parte 4** — Dependencias críticas
   detalladas: flujo transaccional + 3
   dependencias transversales (T-01 sesión, T-02
   permiso, T-03 audit) en profundidad.
5. **Parte 5** — Matriz de criticidad y duración:
   estimación de días por UC, totales por
   criticidad, timeline.
6. **Parte 6** — Patrones de diseño por UC
   aplicados a IACT (decorador RBAC, observer
   AuditEvent, state machine, async ETL,
   throttling de exportación, etc.).

**Conclusión** — métricas finales del proyecto +
próximos pasos.

## Definición de éxito

- Las 12 partes COMPLETAS sin secciones placeholder.
- Cobertura 100 % de los 61 UCs en la matriz.
- Cada criticidad asignada con criterio
  documentado y citable.
- Flujo crítico identificado con justificación
  por cada UC incluido.
- Visualizaciones PlantUML que renderizan limpio
  en ``make html`` 0/0/0.
- Decisiones autónomas registradas en
  ``analyze/decisions-log.md`` con anclaje a UC,
  modelo de dominio, programa Z, o directiva del
  ejecutor.

## Cierre

WP cerrado por orden del ejecutor (I-011).
Condiciones objetivas: 12 partes publicadas + 61
UCs cubiertos + build incremental 0/0/0.
