```yml
project: IACT-docs
work_package: 2026-04-30-22-45-55-rm-uc-relationships-analysis
created_at: 2026-04-30 22:45:55
current_phase: Phase 1 — DISCOVER
status: Activo
author: NestorMonroy
flow: rm
methodology_step: rm-elicitation
```

# WP — Análisis de relaciones de UC del catálogo IACT

## Propósito

Producir el **análisis canónico de relaciones entre
casos de uso** del catálogo IACT, aplicando los skills
``rm-elicitation`` (inventario), ``rm-analysis``
(relaciones formales) y ``rm-specification``
(diagramas finales).

Es el **primer entregable real** del proyecto en
forma de documento RM concreto, no más material
pedagógico. La base la pone el cajón
``_metodologia-aplicacion/`` ya producido.

## Origen

Tras consolidar el cajón metodológico
(``_metodologia-aplicacion/`` con catálogos +
galerías + plantillas) el proyecto avanza al uso
real de los recursos: producir los diagramas
canónicos de IACT.

El primer paso es identificar qué UCs existen
realmente en el catálogo y cómo se relacionan
entre sí — eso permite priorizar qué diagramas
detallados se construyen después.

## Scope

### IN

- **Inventario completo** de UCs IACT por cluster
  (AUTH, USR, ACC, PERM, RPT, ALR, PIP, AUD, LOG).
- **Relaciones include** entre UCs (qué UCs
  invocan a otros como subrutina obligatoria).
- **Relaciones extend** (variaciones condicionales).
- **Generalización** entre UCs y entre actores.
- **Dependencias** entre UCs sin invocación
  directa.
- **Diagrama PlantUML consolidado** de relaciones.
- **Hallazgos** — UCs faltantes, relaciones
  contradictorias, oportunidades de
  refactorización.

### OUT

- Especificación textual completa de cada UC (eso
  pertenece a WPs por cluster).
- Diagramas de secuencia / actividades / estados
  por UC (siguientes WPs).
- Cambios al catálogo de funciones RBAC
  (CNST_030) — solo se documenta lo existente.

## Skills aplicables

Según ``.thyrox/registry/agents/`` y
``.claude/agents/``:

- **rm-elicitation** — recopilación / inventario.
  Phase 1 DISCOVER.
- **rm-analysis** — análisis de relaciones. Phase
  3 ANALYZE.
- **rm-specification** — formalización con
  diagramas. Phase 7 DESIGN/SPECIFY.
- **rm-validation** — verificación de coherencia
  contra BR/CNST. Phase 9 PILOT/VALIDATE.

## Entregables

1. ``discover/uc-inventory.md`` — inventario por
   cluster con descripción breve + actor primario
   + restricciones canónicas asociadas.
2. ``discover/uc-relationships-analysis.md`` —
   análisis de relaciones (include / extend /
   generalización / dependencia) con ejemplos
   PlantUML.
3. ``analyze/uc-catalog-diagram.md`` — diagrama
   consolidado del catálogo con todas las
   relaciones identificadas (Phase 3).
4. ``track/lessons-learned.md`` — al cerrar.

## Hipótesis iniciales (SPECULATIVE)

1. La mayoría de los clusters tienen un UC ancla
   que el resto invoca vía ``<<include>>`` (ej.
   ``UC_PERM_07 verificar permiso``).
2. UC_AUTH_01 es dependencia transversal de casi
   todos los UCs operativos.
3. Las generalizaciones serán raras a nivel UC;
   más comunes a nivel actor (Supervisor /
   Auditor / OperadorETL).
4. Aparecerán **UCs huérfanos** sin entradas
   claras (candidatos a refinamiento o eliminación).

Estas hipótesis se verifican durante la fase
DISCOVER y MEASURE.

## Definición de éxito (exit conditions)

- Inventario completo cubre los 9 clusters.
- Cada UC del inventario tiene actor primario y
  al menos una relación documentada con otro UC.
- Diagrama consolidado renderiza en
  ``make html`` sin warnings.
- Hallazgos categorizados como OBSERVABLE /
  INFERRED / SPECULATIVE per
  evidence-classification.
- Ningún hallazgo SPECULATIVE en la lista de
  conclusiones (gate THYROX I-012).

## Trazabilidad

- **Cajón metodológico**:
  ``source/requisitos/_metodologia-aplicacion/``
  (catálogos, galerías, plantillas listas).
- **Documento canónico de UCs IACT**:
  ``casos-uso-diagramas.rst`` § 15
  (architecture flow).
- **Modelo de dominio**:
  ``analisis-dominio.rst``.
- **Plantilla canónica de UC**:
  ``/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml``.
- **Restricciones**: catálogo de CNST_*.
- **Reglas de negocio**: catálogo de BR_*.
- **Skill applied**: ``rm-elicitation`` (Phase 1)
  + ``rm-analysis`` (Phase 3) +
  ``rm-specification`` (Phase 7).

## Cierre

Este WP no se cierra por inferencia (I-011).
Solo se cierra cuando:

1. Los cuatro entregables están publicados.
2. El diagrama consolidado renderiza limpio.
3. Los hallazgos quedan categorizados y los
   SPECULATIVE se han bajado a OBSERVABLE /
   INFERRED o se han descartado explícitamente.
4. El ejecutor ordena el cierre.
