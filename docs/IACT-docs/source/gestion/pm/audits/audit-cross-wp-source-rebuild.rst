.. meta::
 :artefacto: AUDIT_CROSS_WP_SOURCE_REBUILD
 :tipo: Audit
 :dominio: gestion
 :subdominio: pm/audits
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==================================================
Audit cross-WP — Source Rebuild Strategy (master)
==================================================

.. note::

 Migrado a source/ desde artefacto histórico de WP
 source-rebuild-strategy (Phase 11 TRACK). Audit master
 que consolida hallazgos cross-WP de la reconstrucción
 de ``source/``. Aplica skill ``pm-monitoring``.

1. Premisa
==========

Tras instrucción del ejecutor: "iterar más para encontrar otros
problemas y documentar TODO en el WP correspondiente". Audit
exhaustivo ejecutado vía script ``deep_audit.py`` sobre los 6 WPs
cerrados + ``source/`` global.

**16 hallazgos detectados** distribuidos en 6 WPs.

2. Tabla maestra de hallazgos
=============================

.. list-table::
 :widths: 8 12 50 18 12
 :header-rows: 1

 * - ID
   - Severidad
   - Hallazgo
   - WP afectado
   - Doc remediación
 * - **B-1**
   - CRÍTICO
   - MTM_03 declara "18 roles" (modelo v4.0 legacy)
   - #1 base-cognitiva
   - v3-pending-fixes
 * - **B-2**
   - ALTO
   - glosario.rst NO contiene 7 términos canónicos del RBAC (Grupo
     de Permisos, Agrupador, Permiso Excepcional, Regla SoD,
     Verificación de Permiso, Menú Dinámico, AuditoriaPermiso)
   - #1 base-cognitiva
   - v3-pending-fixes
 * - **E-1**
   - MEDIO
   - STD_007 NO menciona convención inglés/español
     (MODELO_RBAC_v5.2.1 § ESTÁNDAR DE NOMENCLATURA)
   - #2 estándares
   - v2-pending-fixes
 * - **P-1**
   - MEDIO
   - PROC_Excepciones_CNST.rst pendiente (W-4 del
     cross-wp-debt-summary del WP #4)
   - #3 procedimientos
   - v2-pending-fixes
 * - **R-1**
   - ALTO
   - CNST nuevo "Menú Dinámico Obligatorio" (D-RBAC-5 aprobada)
     NO existe
   - #4 restricciones
   - v3-pending-fixes
 * - **R-2**
   - ALTO
   - CNST nuevo "Vocabulario Unificado RBAC" (D-RBAC-6 aprobada)
     NO existe
   - #4 restricciones
   - v3-pending-fixes
 * - **R-3**
   - ALTO
   - CNST_029 NO menciona los 10 grupos predefinidos AGR-001..010
   - #4 restricciones
   - v3-pending-fixes
 * - **R-4**
   - MEDIO
   - CNST_029 NO declara distinción "system groups" vs "custom
     groups" (D-RBAC-4)
   - #4 restricciones
   - v3-pending-fixes
 * - **R-5**
   - ALTO
   - CNST_030 NO declara las 3 reglas SoD atómicas (SOD-001/002/003)
   - #4 restricciones
   - v3-pending-fixes
 * - **G-1**
   - ALTO
   - ADR-GOB-008 "RBAC Coexistencia ACC ↔ PERM" NO existe
     (Hipótesis 1 aprobada lo requiere)
   - #5 gobernanza
   - v2-pending-fixes
 * - **Q-1**
   - ALTO
   - 571 refs CNST legacy (CNST-NNN format) en bodies de UCs
     (script v1 sólo arregló metadata)
   - #6 requisitos
   - v2-pending-fixes
 * - **Q-2**
   - ALTO
   - 118 ocurrencias "Capacidad" en UC_PERM (D-RBAC-1 dice "Función")
   - #6 requisitos
   - v2-pending-fixes
 * - **Q-3**
   - MEDIO
   - 0 cross-refs entre UC_ACC ↔ UC_PERM (coexistencia invisible)
   - #6 requisitos
   - v2-pending-fixes
 * - **Q-4**
   - MEDIO
   - source/requisitos/reglas-negocio/ NO existe (BRs no generados)
   - #6 requisitos
   - v2-pending-fixes
 * - **Q-5**
   - MEDIO
   - source/requisitos/requisitos-funcionales/ NO existe (FRs no
     generados)
   - #6 requisitos
   - v2-pending-fixes
 * - **Q-6**
   - MEDIO
   - source/requisitos/requisitos-no-funcionales/ NO existe (NFRs
     no generados)
   - #6 requisitos
   - v2-pending-fixes

3. Resumen por WP
=================

.. list-table::
 :widths: 30 15 30 25
 :header-rows: 1

 * - WP
   - Hallazgos
   - Severidades
   - Iteración requerida
 * - #1 base-cognitiva
   - 2
   - 1 CRÍTICO + 1 ALTO
   - **v3**
 * - #2 normativa-estandares
   - 1
   - 1 MEDIO
   - **v2**
 * - #3 normativa-procedimientos
   - 1
   - 1 MEDIO
   - **v2**
 * - #4 normativa-restricciones
   - 5
   - 3 ALTO + 1 MEDIO
   - **v3**
 * - #5 normativa-gobernanza
   - 1
   - 1 ALTO
   - **v2**
 * - #6 requisitos
   - 6
   - 2 ALTO + 4 MEDIO
   - **v2**
 * - **Total**
   - **16**
   - 1 CRÍTICO + 8 ALTO + 7 MEDIO
   - **6 iteraciones**

4. Distribución por severidad
=============================

::

 CRÍTICO (1):   B-1 MTM_03 drift "18 roles"
 ALTO (8):      B-2, R-1, R-2, R-3, R-5, G-1, Q-1, Q-2
 MEDIO (7):     E-1, P-1, R-4, Q-3, Q-4, Q-5, Q-6

5. Plan de remediación en cascada
=================================

5.1 Fase 1 — CRÍTICO + 6 ALTOs en RBAC (orden topológico)
---------------------------------------------------------

1. **WP #1 v3** (B-1, B-2): MTM_03 fix + glosario unificado
2. **WP #4 v3** (R-1..R-5): 2 CNSTs nuevos + enriquecer
   CNST_029/030
3. **WP #5 v2** (G-1): ADR-GOB-008
4. **WP #6 v2** (Q-1, Q-2): refs CNST en bodies + Capacidad →
   Función

5.2 Fase 2 — MEDIOs
-------------------

5. **WP #2 v2** (E-1): STD_007 con convención idioma
6. **WP #3 v2** (P-1): PROC_Excepciones_CNST
7. **WP #6 v2** (Q-3, Q-4, Q-5, Q-6): cross-refs + BRs + FRs + NFRs

5.3 Estimación total
--------------------

~10-15 horas de trabajo distribuido en 6 iteraciones.

6. Hallazgo metodológico
========================

El cierre prematuro de WP #6 ocurrió por NO verificar
``analyze/cross-wp-rbac-audit.md`` antes de Phase 11 TRACK. Para
prevenir esto:

.. admonition:: Protocolo nuevo

 Antes de cerrar cualquier WP, ejecutar ``deep_audit.py`` (o
 equivalente futuro como skill THYROX) sobre TODO el ``source/`` +
 WPs cerrados. Si hay hallazgos CRÍTICOS o ALTOs en WPs
 dependientes, NO cerrar — primero resolver vía iteración
 correspondiente.

Documentado como guideline en ``.claude/rules/`` y como step
explícito en skill ``workflow-track``.

7. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``pm-monitoring`` (PMBOK — Monitoring & Controlling)
 * - **WP origen**
   - source-rebuild-strategy (2026-04-28)
 * - **Migrado a source**
   - 2026-04-30 (sub-WP md-references-audit)
 * - **Deep-reviews relacionados**
   - | :doc:`/gestion/pm/lecciones-aprendidas/deep-review-rbac-coherencia-artefactos-canonicos`
     | :doc:`/gestion/pm/lecciones-aprendidas/deep-review-rbac-drift-residual-base-cognitiva`
