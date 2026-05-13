.. meta::
 :artefacto: DEEP_REVIEW_REMEDIATION_FASES_1_2
 :tipo: Deep-Review
 :dominio: gestion
 :subdominio: pm/lecciones-aprendidas
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==================================================
Deep-Review Remediation Fases 1+2 (source-rebuild)
==================================================

.. note::

 Migrado a source/ desde artefacto histórico de WP
 source-rebuild-strategy (Phase 11 TRACK). Deep-review
 independiente sobre la remediación de Fases 1 y 2 del WP.
 Aplica skill ``workflow-track``.

1. Resumen ejecutivo
====================

**Veredicto:** PARTIAL.

Las Fases 1+2 cierran correctamente los **15 hallazgos del audit**
(B-1, B-2, R-1..R-5, G-1, Q-1..Q-6, E-1, P-1) en sus puntos
focales: los 4 artefactos nuevos (CNST_032, CNST_033, ADR-GOB-008,
PROC_Excepciones_CNST) son coherentes entre sí, las 8 decisiones
D-RBAC están reflejadas en source/, y las cross-refs ACC↔PERM
existen.

Sin embargo, las 6 iteraciones rápidas introdujeron **drift residual
no contemplado por el audit**:

- bloques internos de MTM_03 que conservan el modelo v4.0 (18 roles,
  R001/R016/R017),
- el glosario apunta a CNST_033 como "pendiente de creación" cuando
  ya existe,
- conteos de funciones inconsistentes (42 vs 44) entre artefactos
  sincronizados el mismo día.

Ningún drift bloquea uso operativo, pero contradicen explícitamente
CNST_033 y D-RBAC-1.

2. Hallazgos del deep-review
============================

2.1 F-DR-1 (ALTO) — MTM_03 conserva drift v4.0 fuera de § 3.2
-------------------------------------------------------------

``source/base-cognitiva/_taxonomias-y-metamodelos/metamodelos/mtm-03-metamodelo-rbac.rst:193``
declara ``codigo: VARCHAR(50) // R001-R018``; líneas 404-410
contienen tabla *PARES CONFLICTIVOS IACT* con R016/R017/R001
(modelo v4.0); líneas 654-673 (§ 8.2) tabula 4 roles legacy
``USERS_FULL_MANAGER``, ``SYSTEM_ADMIN``.

La fix de B-1 sólo enriqueció § 3.2 con la nota v5.2.x sin purgar
las tablas previas/posteriores. Contradice CNST_033 dentro del
propio doc.

2.2 F-DR-2 (ALTO) — Glosario contradice estado real de CNST_033
---------------------------------------------------------------

``source/base-cognitiva/glosario.rst:334-335`` dice "ver CNST_033
Vocabulario Unificado RBAC, **pendiente de creación en WP #4 v3**".
CNST_033 ya existe (``cnst-033-vocabulario-unificado-rbac.rst``,
version 1.0.0). Texto stale del WP #1 v3 no actualizado al cerrar
WP #4 v3.

2.3 F-DR-3 (ALTO) — Conteo inconsistente 42 vs 44 funciones
-----------------------------------------------------------

El doc de formalización RBAC declara "44 (v5.1.1) o 42 (v5.2.1)".
CNST_029 no fija número. UC_ACC_01 (3 sitios: línea 62, 180, 435)
repite "44 disponibles" en flujo, FR-ACC-003 y diagramas.
ADR-GOB-008:36 dice "Catálogo cerrado: 42 funciones".

Tres artefactos canónicos sincronizados el 2026-04-29 con números
distintos. D-RBAC-x no resolvió este conflicto.

2.4 F-DR-4 (MEDIO) — requisitos-funcionales/index carece de metadata
--------------------------------------------------------------------

``source/requisitos/requisitos-funcionales/index.rst:1-43`` no tiene
bloque ``.. meta::`` con ``version``, ``fecha_creacion``, ``autor``,
``estado`` — a diferencia de ``reglas-negocio/index.rst:1-12``
(creado el mismo día con metadata completa).

Q-5 cerrado de forma desigual frente a Q-4. Además, el toctree
expone ``users/``, ``auth/``, ``access/`` (subdir UC) en cajón FR —
confusión categorial: requisitos funcionales ≠ casos de uso.

2.5 F-DR-5 (MEDIO) — UC_PERM_01 conserva vocabulario PERM granular
------------------------------------------------------------------

``uc-perm-01/index.rst:115`` ("AuditoriaPermiso"),
:326 ("usuarios_grupos"), :433 ("auditoria_permisos") usan tablas
PERM. Aunque el grep de "Capacidad" da 0 (Q-2 cerrado para ese
término concreto), CNST_033 también canonifica
``UsuarioGrupo→UserGroupAssignment`` y
``AuditoriaPermiso→PermissionAudit``.

El UC mantiene vocabulario tabla-PERM en flujos y RFs. Q-2 fue
interpretado de forma estrecha (solo "Capacidad").

2.6 F-DR-6 (MEDIO) — reglas-negocio/index salta BR_016
------------------------------------------------------

Toctree (``source/requisitos/reglas-negocio/index.rst:28-46``) lista
BR_001..BR_015, luego BR_017..BR_020. Falta BR_016 sin nota
explicativa.

Verificación: 19 archivos ``br-*.rst`` en disco coinciden con el
toctree, pero el gap numérico es incoherente con la convención
sequential implícita y con MTM_03:725 que referencia "BR_006".

2.7 F-DR-7 (MEDIO) — CNST_032 cita CNST_031 con doc-ref inexistente
--------------------------------------------------------------------

``cnst-032-menu-dinamico-obligatorio.rst:80`` y ``cnst-029:80``
referencian ``:doc:`CNST_031_Permisos_Temporales_Maximo_6_Meses```.

Si CNST_031 vive con otro nombre canónico, los ``:doc:`` rompen el
build Sphinx.

2.8 F-DR-8 (BAJO) — ADR-GOB-008 cita "75% completa" sin método
--------------------------------------------------------------

``adr-gob-008-rbac-coexistencia-acc-perm.rst:42, 104`` afirma
"Implementación backend 75% completa". Viola
``.claude/rules/calibration-verified-numbers.md`` — número sin
método de verificación citado. Severidad baja porque es contexto,
no fundamento de la decisión.

3. Aciertos detectados
======================

1. **Coherencia D-RBAC fuerte.** Las 8 decisiones (D-RBAC-1..8)
   están explícitamente referenciadas con ID en CNST_032 (origen
   D-RBAC-5), CNST_033 (D-RBAC-1, D-RBAC-6), CNST_029 (D-RBAC-4),
   CNST_030 (D-RBAC-7) y consolidadas en ADR-GOB-008 § "Decisiones
   Relacionadas" — trazabilidad bidireccional impecable.
2. **Cross-refs UC_ACC↔UC_PERM efectivas.** Ambos UCs contienen el
   bloque ``.. note:: Vista alternativa (coexistencia)`` con
   ``:doc:`` recíproco al ADR-GOB-008, cerrando Q-3 con simetría.
3. **PROC_Excepciones_CNST cubre matriz por criticidad** (§ 4.3)
   con vigencias máximas alineadas a la severidad declarada en cada
   CNST — diseño consistente con el catálogo.
4. **STD_007 § 7 idioma tabla canónica** (líneas 399-447) cubre 13
   tipos de elemento, supera el alcance del hallazgo E-1.
5. **Glosario § H** (8 términos) cubre los 7 términos de B-2 +
   AuditoriaPermiso, cada uno con ``:doc:`` al CNST canónico.

4. Recomendaciones
==================

.. list-table::
 :widths: 15 85
 :header-rows: 1

 * - Hallazgo
   - Acción concreta
 * - F-DR-1
   - Purgar líneas 193, 404-410, 654-673 de MTM_03 (o marcarlas
     como "ejemplos legacy obsoletos"); regenerar tabla 8.2 con
     grupos AGR-001..010.
 * - F-DR-2
   - Edit en glosario.rst:334-335: cambiar "pendiente de creación"
     por ``:doc:`` directo al CNST_033 ya creado.
 * - F-DR-3
   - Decisión D-RBAC-9 nueva: fijar el número canónico (42 o 44).
     Propagar a UC_ACC_01, rbac-formalization, ADR-GOB-008 y al
     catálogo de funciones.
 * - F-DR-4
   - Agregar bloque ``.. meta::`` a requisitos-funcionales/index.rst
     simétrico al de reglas-negocio/index.rst. Considerar mover
     users/auth/access del toctree FR.
 * - F-DR-5
   - Q-2 v2: extender migración Capacidad→Función a tabla
     UsuarioGrupo→UserGroupAssignment y
     AuditoriaPermiso→PermissionAudit per CNST_033 § 2.1.
 * - F-DR-6
   - Documentar gap BR_016 en reglas-negocio/index.rst (placeholder
     o nota "BR_016 deprecado/reservado"); o crear el BR faltante.
 * - F-DR-7
   - Verificar build Sphinx. Si CNST_031 difiere de naming, fix
     ``:doc:`` en CNST_032:80, CNST_029:80, CNST_030:244.
 * - F-DR-8
   - Reemplazar "75% completa" en ADR-GOB-008:42, :104 por
     afirmación calibrada o eliminar si no hay método de medida.

5. Documentos analizados
========================

15/15 documentos del set bajo deep-review:

- :doc:`/normativa/restricciones/cnst-032-menu-dinamico-obligatorio`
- :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`
- :doc:`/normativa/restricciones/cnst-029-rbac-modelo-plano`
- :doc:`/normativa/restricciones/cnst-030-reglas-de-separacion-de-funciones-sod`
- :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`
- :doc:`/normativa/estandares/std-007-convencion-naming`
- :doc:`/base-cognitiva/glosario`
- :doc:`/requisitos/casos-uso/access/uc-acc-01/index`
- :doc:`/requisitos/casos-uso/permissions/uc-perm-01/index`
- :doc:`/requisitos/reglas-negocio/index`
- :doc:`/requisitos/requisitos-funcionales/index`
- (audit cross-WP) :doc:`/gestion/pm/audits/audit-cross-wp-source-rebuild`
- (rbac-formalization) :doc:`/gestion/evidencia/rbac-historia/formalizacion-modelo-rbac`

6. Trazabilidad
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
   - :doc:`deep-review-rbac-drift-residual-base-cognitiva`
 * - **Audit master**
   - :doc:`/gestion/pm/audits/audit-cross-wp-source-rebuild`
