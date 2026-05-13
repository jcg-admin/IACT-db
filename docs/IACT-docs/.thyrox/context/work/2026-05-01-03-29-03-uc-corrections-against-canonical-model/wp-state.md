```yml
project: IACT-docs
work_package: 2026-05-01-03-29-03-uc-corrections-against-canonical-model
created_at: 2026-05-01 03:29:03
current_phase: Phase 11 — TRACK (closed)
closed_at: 2026-05-01 04:55:00
status: Cerrado v1.0.0 — 61 / 61 UCs corregidos, build 0/0/0
author: NestorMonroy
flow: rm
methodology_step: rm-management
language_convention: "Identifiers EN (clases del modelo); prose ES; constraints en versiones vigentes"
predecessor_wp: 2026-05-01-02-01-06-domain-model-canonization
```

# WP — Corrección sistemática de los 61 UCs contra el modelo canónico

## Propósito

Recorrer **los 61 UCs vigentes** en
``source/requisitos/casos-uso/`` y aplicar las
correcciones necesarias para alinearlos con:

1. **Modelo canónico de dominio**:
   :doc:`/arquitectura-tecnica/modelo-dominio-iact`
   v1.0.0 (25 clases en 7 bounded contexts,
   identificadores en inglés).
2. **Modelo RBAC vigente**: ``modelo-rbac-iact.rst``
   v5.4.0 (61 funciones, decisiones D-01..D-11).
3. **Constraints en versiones vigentes**: BR-009
   v2.0.0, BR-011 v2.0.0, CNST-019 v3.0.0,
   CNST-020 v3.0.0.
4. **Convenciones del proyecto**:
   ``source/base-cognitiva/_uml/*`` (PlantUML,
   estructura de class diagrams) y
   ``source/requisitos/_metodologia-aplicacion/*``
   (plantillas de UC, taxonomía, diagramas
   aplicados).

## Modo de ejecución

El ejecutor delegó decisiones autónomas
(2026-05-01). Loop hasta corregir todos los UCs.
Sin pausas para confirmación salvo que:

- Aparezca un conflicto entre el modelo canónico y
  el corpus que requiera decisión arquitectónica
  no derivable.
- Se detecte un riesgo de pérdida de información
  (eliminar contenido sin trazabilidad).
- Build incremental falle.

## Scope

### IN

- Revisión y corrección de los 61 UCs en
  ``source/requisitos/casos-uso/`` por cluster.
- Reemplazo de citas obsoletas a constraints (e.g.
  ``BR-009 v1.x`` → ``v2.0.0``, ``CNST-019 v2.x``
  → ``v3.0.0``).
- Eliminación de menciones residuales al concepto
  ``Segmento`` / ``SegmentoDatos``.
- Corrección de referencias colgantes (``UC_ACC_07``
  inexistente) — limpiar la referencia, no
  restaurar el UC.
- Alineación de ``UC Relacionados`` en la
  Trazabilidad para los 16 UCs que no lo exponen.
- Renombrado de funciones citadas a la versión
  v5.4.0 (``manage_sessions`` →
  ``view_own_sessions``, ``delete_users`` →
  ``deactivate_users``, etc).
- Cita de la clase canónica del modelo de dominio
  cuando corresponda en la sección "11.
  Restricciones de Arquitectura" o sección 13
  "Trazabilidad".
- Verificación de cumplimiento STD_001 (sin emojis
  prohibidos), STD_007 (kebab-case en filenames),
  CLEAN CODE (naming).

### OUT

- Cambio del idioma del UC (los UCs siguen en
  español; sólo los identificadores citados de
  clases/funciones quedan en inglés).
- Restauración del concepto ``Segmento`` / UC_ACC_07
  / UC_ACC_06 / BR-012 (Z.1.C los descartó por
  Camino C).
- Modificación del modelo RBAC v5.4.0 (cerrado por
  Z.2).
- Modificación del modelo de dominio canónico
  v1.0.0 (cerrado por el WP predecesor).
- Crear UCs nuevos.

## Skills aplicables

- ``rm-management`` (Stage 11/cíclico) — gestión de
  cambios sobre artefactos vigentes.
- ``rm-validation`` por cada UC corregido contra el
  modelo canónico.

## Entregables

1. ``discover/uc-audit-matrix.md`` — auditoría
   inicial de los 61 UCs identificando defectos por
   UC (clases mal citadas, constraints obsoletos,
   referencias colgantes, campo Trazabilidad
   incompleto, etc).
2. ``execute/per-cluster/{cluster}-corrections.md``
   — bitácora de correcciones por cluster
   (AUTH/USR/ACC/PERM/RPT/ALR/PIP/AUD/LOG).
3. ``track/lessons-learned.md`` y
   ``track/{wp}-changelog.md`` al cierre.

## Definición de éxito

- 61 / 61 UCs corregidos contra el modelo canónico
  vigente.
- Cada UC cita: la(s) clase(s) del modelo sobre la
  que opera, la función RBAC v5.4.0 que lo
  autoriza, los constraints en versiones vigentes.
- Cero menciones residuales a ``Segmento`` /
  ``SegmentoDatos``.
- Cero referencias a archivos eliminados.
- ``UC Relacionados`` poblado en los 61 UCs (o
  excepción documentada para los UCs PERM como
  vista técnica).
- Build incremental ``make html`` con 0 warnings,
  0 errors al cierre.
- Gates I-011, I-012, I-013, I-015 satisfechos.

## Cierre

WP cerrado por orden del ejecutor (I-011) cuando
los 61 UCs estén corregidos y el build sea verde.
Ninguno antes.
