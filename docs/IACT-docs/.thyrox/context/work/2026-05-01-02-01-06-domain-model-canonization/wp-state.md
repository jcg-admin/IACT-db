```yml
project: IACT-docs
work_package: 2026-05-01-02-01-06-domain-model-canonization
created_at: 2026-05-01 02:01:06
current_phase: Phase 11 — TRACK (closed)
closed_at: 2026-05-01 04:30:00
status: Cerrado v1.0.0 — modelo canónico publicado, build 0/0/0
author: NestorMonroy
flow: rm
methodology_step: cerrado
language_convention: "Identifiers EN (NOM_001 § 2.3); prose, comments and PlantUML notes ES on integration to source/"
```

# WP — Canonización del modelo de dominio IACT

## Propósito

Establecer el **diagrama de clases canónico del
dominio IACT** como artefacto del proyecto (no como
extracto pedagógico) y validar el inventario de UCs
contra ese modelo. Es el cimiento que faltaba para
que cualquier análisis posterior de relaciones de
UC opere sobre base estable.

## Origen

El WP previo
``2026-04-30-22-45-55-rm-uc-relationships-analysis``
intentó analizar relaciones entre los 61 UCs del
catálogo y produjo
``discover/uc-relationships-analysis.md``, que quedó
marcado como **Hipótesis pendiente de validación**
porque:

- Las relaciones se infirieron por ingeniería
  inversa sobre los ``.rst`` existentes (una sola
  fuente, sin elicitación con stakeholders) — red
  flag explícita del skill ``rm-elicitation``.
- ``analisis-dominio.rst § 11`` declara **97 UCs**
  mientras el inventario verifica **61 UCs**.
  Discrepancia de 36 sin reconciliar.
- El diagrama de clases existe sólo como extracto
  embebido en
  ``_metodologia-aplicacion/analisis-dominio.rst § 7``,
  no como artefacto canónico del proyecto.
- Hallazgo H-07: UC_USR_01 referencia ``UC_ACC_07``
  que no existe en el inventario. Indica catálogo
  inestable.

El WP previo permanece **abierto** (no se cierra)
con sus hallazgos como insumo. Este nuevo WP
construye la base que el anterior necesitaba.

## Principios metodológicos

El modelo de dominio se elabora aplicando
**Domain-Driven Design** (Evans, *Domain-Driven
Design: Tackling Complexity in the Heart of
Software*, 2003) — referencia normativa, sin copia
de su texto. Principios operativos:

1. **Modelo de dominio primero** — antes que código,
   antes que diagrama de UC, antes que análisis de
   relaciones.
2. **Lenguaje ubicuo** — un solo vocabulario para
   ingeniería, producto y negocio sobre el mismo
   dominio.
3. **Diagramado** — el modelo no es un texto narrado;
   se materializa en un diagrama de clases UML que
   sirve como referencia compartida.
4. **Colaborativo** — el modelo se acuerda con
   stakeholders, no se infiere desde código existente.
5. **Evolutivo** — se modifica cuando aparecen
   nuevos requisitos; se referencia en cada nueva
   feature para validar encaje.

## Scope

### IN

- **Diagrama de clases canónico de IACT** publicado
  como artefacto propio (no como extracto en cajón
  pedagógico). Incluye:
  - Entidades del dominio (Usuario, Sesion,
    Funcion, Grupo, SegmentoDatos, Llamada,
    Reporte, Metrica, EjecucionETL, ErrorETL,
    Alerta, Umbral, BuzonInterno,
    EventoAuditoria, y cualquier otra justificada).
  - Atributos relevantes con tipo y restricciones
    canónicas (CNST_*).
  - Operaciones / responsabilidades por clase
    (verbos del dominio).
  - Asociaciones con cardinalidad y semántica.
  - Generalizaciones donde apliquen (jerarquías
    de actor, tipos de reporte).
  - Notas con BR_* y CNST_* aplicables.
- **Reconciliación 61 vs 97 UCs** — explicación
  formal de la discrepancia: ¿son 61 los
  vigentes y 97 incluye deprecados? ¿la cifra de
  ``analisis-dominio.rst § 11`` está obsoleta?
- **Validación cruzada** — cada UC del inventario
  opera sobre clases del modelo; cada clase del
  modelo aparece como sujeto / objeto en ≥1 UC.
- **Lenguaje ubicuo** — glosario que normaliza la
  nomenclatura entre ``.rst`` (algunos kebab,
  otros canónico) y el modelo.

### OUT

- Especificaciones detalladas de cada UC — eso es
  trabajo del WP previo o de WPs por cluster.
- Análisis de relaciones inter-UC — espera a que
  esta base esté firme.
- Implementación SQL / ORM del modelo — eso es
  Stage 10 EXECUTE de un WP de
  arquitectura técnica.
- Cambios al catálogo de funciones RBAC
  (CNST_030).

## Skills aplicables

- **rm-elicitation** (Stage 1 DISCOVER) — la
  elicitación aquí es **structured analysis of
  existing artifacts + confirmación con
  ejecutor** como proxy de stakeholder. Documentar
  esa adaptación como deviation explícita del
  skill.
- **rm-analysis** (Stage 3 ANALYZE) — aplicar IEEE
  830 al inventario de clases candidatas.
- **rm-specification** (Stage 7
  DESIGN/SPECIFY) — formalizar el diagrama
  canónico.
- **rm-validation** (Stage 9 PILOT/VALIDATE) —
  cruzar cada UC contra el modelo.

## Entregables

1. ``discover/domain-elicitation.md`` — plan de
   elicitación adaptada (analisis del corpus +
   confirmación de ejecutor), fuentes consultadas,
   decisión sobre la 61 vs 97 UCs.
2. ``discover/risk-register.md``
3. ``discover/exit-conditions.md``
4. ``analyze/domain-class-candidates.md`` —
   sustantivos del corpus → clases candidatas;
   IEEE 830 quality check; resolución de
   conflictos (61 vs 97, kebab vs canónico, etc).
5. ``design/iact-domain-model.md`` + el PlantUML
   canónico que se promueve a
   ``source/requisitos/casos-uso/index.rst`` o un
   artefacto propio en
   ``source/requisitos/`` (a decidir en Stage 6).
6. ``pilot/uc-vs-domain-validation.md`` —
   matriz UC × clase con cobertura y huérfanos.
7. ``track/lessons-learned.md`` al cierre.

## Hipótesis iniciales (SPECULATIVE)

1. La discrepancia 61 vs 97 UCs se explica por
   UCs declarados pero no escritos, o por
   renumeración del catálogo. Se verifica leyendo
   commits previos del corpus + index.rst.
2. Las 14 clases de
   ``analisis-dominio.rst § 7`` cubren ≥80% del
   dominio operativo, pero faltan al menos:
   ``Filtro``, ``ExportJob``, ``Permiso``
   (excepcional), ``ConfiguracionUmbral``.
3. La nomenclatura kebab ``uc-rpt-NN`` /
   ``uc-log-NN`` corresponde a UCs creados en una
   ola posterior con plantilla distinta — es
   deuda de catálogo, no error semántico.
4. El modelo de dominio actual no documenta
   explícitamente las **invariantes de
   transición** (qué cambios de estado son
   válidos en Sesion, Alerta, EjecucionETL) — son
   diagramas de estado complementarios al de
   clases.

Estas hipótesis se verifican durante DISCOVER y
ANALYZE.

## Definición de éxito (exit conditions)

- Diagrama de clases canónico publicado como
  artefacto del proyecto (no extracto), referenciado
  desde ``index.rst`` correspondiente.
- 100% de los UCs del inventario apuntan a ≥1
  clase del modelo.
- 100% de las clases del modelo aparecen en ≥1 UC
  (no hay clases huérfanas).
- Discrepancia 61 vs 97 resuelta por escrito.
- Glosario de lenguaje ubicuo publicado.
- Ningún hallazgo SPECULATIVE en conclusiones (gate
  THYROX I-012).
- ``make html`` con 0 warnings, 0 errors.

## Trazabilidad

- WP previo (mantenido abierto):
  ``2026-04-30-22-45-55-rm-uc-relationships-analysis``.
- Inventario UC verificado:
  ``${wp-previo}/discover/uc-inventory.md``.
- Análisis hipotético no validado:
  ``${wp-previo}/discover/uc-relationships-analysis.md``.
- Modelo de dominio fuente (extracto pedagógico):
  ``source/requisitos/_metodologia-aplicacion/analisis-dominio.rst``
  § 7 (diagrama integrado), § 11 (referencia "97
  UCs" a reconciliar).
- UCs del catálogo:
  ``source/requisitos/casos-uso/`` (61 UCs
  verificados).
- Plantilla canónica de UC:
  ``/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml``.

## Relación con DDD (Evans 2003)

Este WP adopta principios de DDD como marco
metodológico, citados como referencia normativa
externa. La aplicación al dominio IACT es original;
no se transcribe ni se parafrasea contenido del
libro. Cuando un concepto DDD se usa
(``ubiquitous language``, ``bounded context``,
``aggregate``) se cita la fuente y se traduce a
vocabulario IACT.

## Cierre

Este WP no se cierra por inferencia (I-011). Solo
se cierra cuando:

1. Los siete entregables están publicados.
2. El diagrama canónico renderiza limpio en
   ``make html``.
3. La validación UC × clase es 100%.
4. La discrepancia 61 vs 97 está resuelta.
5. El ejecutor ordena el cierre.

Cuando este WP cierre, el WP previo
``rm-uc-relationships-analysis`` puede retomarse
sobre base firme.
