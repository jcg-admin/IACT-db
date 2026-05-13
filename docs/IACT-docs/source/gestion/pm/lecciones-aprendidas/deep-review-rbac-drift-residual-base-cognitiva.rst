.. meta::
 :artefacto: DEEP_REVIEW_RBAC_DRIFT_RESIDUAL
 :tipo: Deep-Review
 :dominio: gestion
 :subdominio: pm/lecciones-aprendidas
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==============================================================
Deep-Review RBAC — Drift residual en base-cognitiva (Fase 3)
==============================================================

.. note::

 Migrado a source/ desde artefacto histórico de WP
 source-rebuild-strategy (Phase 11 TRACK). Deep-review
 independiente sobre la Fase 3 de remediación RBAC, enfocado
 en drift v4.0 residual fuera del set focal.
 Aplica skill ``workflow-track``.

1. Resumen ejecutivo
====================

**Veredicto:** PARTIAL.

Los 7 fixes de Fase 3 cierran correctamente sus puntos focales
(MTM_03 § 3.2/§ 4.3/§ 8.2, glosario:334, conteo 42 en los 9 sitios
listados, metadata FR-index, nota BR_016, ADR-GOB-008 calibración).
Sin embargo:

- F-DR-1 fue interpretado **estrictamente como "MTM_03"** y dejó
  intacto el mismo drift v4.0 en **5 docs hermanos** del cajón
  ``_ontologia-sbvr/`` y ``_taxonomias-y-metamodelos/``.
- La nota BR_016 ("reservado / no asignado") **contradice**
  documentación viva en FND_05 y TPL_BR que afirman
  BR_016 = "Tasa Abandono".

Ningún fix introduce refs Sphinx rotas, pero la cohesión cross-doc
del modelo RBAC sigue rota fuera del set de 9 sitios atendidos.

2. Verificación de fixes Fase 3
===============================

.. list-table::
 :widths: 15 20 65
 :header-rows: 1

 * - ID
   - Estado
   - Comentario
 * - F-DR-1
   - **Parcial**
   - MTM_03:193, 404-410, 654-680 OK. Pero 5 docs hermanos
     conservan R001-R018, USERS_FULL_MANAGER, SYSTEM_ADMIN —
     drift v4.0 idéntico al diagnosticado.
 * - F-DR-2
   - **Completo**
   - glosario:331-335 ahora ``:doc:`` directo a CNST_033.
 * - F-DR-3
   - **Completo**
   - grep "44 funciones" → 0 hits. "42 funciones" en 11 sitios.
 * - F-DR-4
   - **Completo**
   - metadata 10 campos en
     ``requisitos-funcionales/index.rst:1-11``.
 * - F-DR-5 (deferido)
   - **Razonable**
   - UsuarioGrupo/AuditoriaPermiso son nombres de tablas Django
     reales canonificados en CNST_033 § 2. Diferir es defendible.
 * - F-DR-6
   - **Incompleto / contradictorio**
   - Nota dice "BR_016 reservado" pero FND_05:183, TPL_BR:84/95/125,
     BR_018:230 lo citan como "BR_016 = Tasa Abandono".
 * - F-DR-7
   - **Completo**
   - filename CNST_031 verificable.
 * - F-DR-8
   - **Completo**
   - "75% completa" reformulado a "estado documentado en
     GAP_ANALYSIS".

3. Hallazgos del deep-review
============================

3.1 F3-DR-1 (ALTO) — Drift v4.0 sigue en 5 docs hermanos de MTM_03
------------------------------------------------------------------

``SBVR_02:117, 269-270``, ``SBVR_03:130, 364-366, 464, 467-472``,
``SBVR_04:249-250, 410, 418, 424``, ``SBVR_05:78, 277-278, 322,
334-335, 447``, ``MTM_01:587, 593``, ``TXM_01:122``,
``TXM_03:205, 222`` contienen R001-R018, USERS_FULL_MANAGER,
SYSTEM_ADMIN, SECURITY_ADMIN.

Mismo patrón que F-DR-1 original. El fix se interpretó como "purgar
MTM_03" en vez de "purgar drift v4.0 en ``base-cognitiva/``".

3.2 F3-DR-2 (ALTO) — BR_016 contradicción semántica activa
----------------------------------------------------------

``reglas-negocio/index.rst:48-53`` afirma "reservado / no asignado".
``FND_05:183`` y ``TPL_BR_Business_Rules.rst:84, 95, 125`` afirman
"BR_016 = Tasa Abandono" como ejemplo canónico. ``BR_018:230`` lo
cita como complementario.

La nota describe ausencia física pero ignora referencias semánticas
activas. Decisión necesaria: crear el archivo BR_016 o cambiar las
refs.

3.3 F3-DR-3 (MEDIO) — MTM_03 § 8.2 incompleta
---------------------------------------------

``MTM_03_Metamodelo_RBAC.rst:651-684`` "Funciones por Grupo
Predefinido" lista solo **5** de los 10 grupos (AGR-001, 002, 004,
006, 010), faltando AGR-003, 005, 007, 008, 009.

La tabla § 3.2:226-239 sí lista los 10. Inconsistencia interna del
mismo doc.

3.4 F3-DR-4 (BAJO) — Versión RBAC mixta v5.1.1 vs v5.2.x
--------------------------------------------------------

``FND_00:232, 268`` y ``MTM_03:732`` usan "v5.1.1". ``MTM_03:207,
404``, ``ADR-GOB-008`` usan "v5.2.x". Mismo modelo, dos etiquetas.

3.5 F3-DR-5 (BAJO) — requisitos-funcionales/index toctree categorial
--------------------------------------------------------------------

Aunque metadata fue agregada (F-DR-4 cerrado),
``requisitos-funcionales/`` sigue exponiendo subdirectorios UC en
su toctree (issue heredado del deep-review previo, no parte del
fix). Reservar para futuro WP.

4. Aciertos detectados
======================

1. **Conteo 42 funciones** propaga uniformemente — grep "44" da 0
   hits.
2. **F-DR-2 fix elegante** — ``:doc:`` directo a CNST_033 elimina
   la nota stale.
3. **MTM_03 § 3.2 reescrita con tabla AGR-001..AGR-010 completa** y
   SoD-001/002/003 — supera el scope mínimo del fix.
4. **F-DR-8 reformulación** evita número no calibrado, redirige a
   GAP_ANALYSIS — consistente con
   ``calibration-verified-numbers.md``.

5. Recomendaciones
==================

.. list-table::
 :widths: 15 85
 :header-rows: 1

 * - Hallazgo
   - Acción concreta
 * - F3-DR-1
   - Crear Fase 4 con scope explícito:
     ``grep -rn "R0[0-1][0-9]\|USERS_FULL_MANAGER\|SYSTEM_ADMIN\|SECURITY_ADMIN" source/base-cognitiva/``
     y purgar las ~25 ocurrencias en SBVR_02..05, MTM_01, TXM_01,
     TXM_03 con la misma plantilla aplicada a MTM_03 § 3.2.
 * - F3-DR-2
   - Decidir entre dos vías: (a) crear ``br-016-tasa-abandono.rst``;
     (b) actualizar FND_05:183 y TPL_BR para usar otro BR de
     cálculo. La nota actual no puede coexistir con las refs
     activas.
 * - F3-DR-3
   - Completar tabla MTM_03 § 8.2 con los 5 AGR faltantes (003, 005,
     007, 008, 009).
 * - F3-DR-4
   - Adoptar una versión canónica (recomendado v5.2.x) y propagar
     a FND_00:232, 268, MTM_03:732.
 * - F3-DR-5
   - Diferir a un WP de reorganización categorial.

6. Documentos analizados
========================

9 archivos + greps complementarios:

- ``source/base-cognitiva/_taxonomias-y-metamodelos/metamodelos/mtm-03-metamodelo-rbac.rst``
- :doc:`/base-cognitiva/glosario`
- ``source/base-cognitiva/_fundamentos-conceptuales/fnd-00-contexto-y-jerarquia.rst``
- :doc:`/requisitos/casos-uso/access/uc-acc-01/index`
- ``source/requisitos/reglas-negocio/br-006-rbac-flat-nist.rst``
- :doc:`/requisitos/reglas-negocio/index`
- :doc:`/requisitos/requisitos-funcionales/index`
- :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`
- :doc:`deep-review-rbac-coherencia-artefactos-canonicos` (referencia)

Greps de verificación ejecutados:

- drift R001-R018 / USERS_FULL_MANAGER en ``source/``
- conteo 42 vs 44 en docs
- BR_016 cross-references
- versiones v5.x mezcladas

7. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``workflow-track`` (Phase 11 TRACK)
 * - **WP origen**
   - source-rebuild-strategy (2026-04-28)
 * - **Migrado a source**
   - 2026-04-30 (sub-WP md-references-audit)
 * - **Documento hermano**
   - :doc:`deep-review-rbac-coherencia-artefactos-canonicos`
 * - **Audit master**
   - :doc:`/gestion/pm/audits/audit-cross-wp-source-rebuild`
