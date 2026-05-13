.. meta::
 :artefacto: HIST_RBAC_003
 :tipo: Documento Historico
 :dominio: gestion
 :subdominio: evidencia/rbac-historia
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-01-13
 :ultimo_cambio: 2026-04-29
 :autor: Equipo IACT
 :clasificacion: Interno

.. _hist-rbac-003:

=================================================================
Decisiones Modulares — Debate "8 vs 9 modulos" (Decision Log)
=================================================================

.. note::

 **Documento historico — Decision Log.**

 Extracto de la PARTE 3 + PARTE 4 del analisis profundo de
 decisiones de modulos IACT (enero 2026). Documenta el debate
 historico que llevo a la estructura final de **8 modulos**
 con SEC_RULES integrado en RBAC_CORE.

 NO es spec vigente. Para spec vigente ver
 :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` y los 8
 ARQ_MOD_001..008 en :doc:`/arquitectura-tecnica/modulos/index`.

----

1. Contexto del debate
======================

Durante el diseno modular del sistema IACT (enero 2026), distintos
documentos de analisis llegaron a conclusiones contradictorias
sobre la cantidad de modulos funcionales:

- Algunos documentos: **8 modulos** con ``SEC_RULES`` integrado
  dentro de ``RBAC_CORE``.
- Otros documentos: **9 modulos** con ``SEC_RULES`` como modulo
  separado (MOD-09).

El debate quedo registrado para trazabilidad — se resolvio por
**8 modulos** (decision vigente).

----

2. Contradiccion principal documentada
======================================

.. list-table::
 :header-rows: 1
 :widths: 40 12 28 20

 * - Documento
   - Modulos
   - SEC_RULES
   - RBAC_CORE
 * - "Identificando los modulos funcionales"
   - **8**
   - **Integrado en RBAC_CORE**
   - MOD-09
 * - "Orden correcto de modulos"
   - 9
   - MOD-09 separado
   - MOD-03
 * - "Analisis modulo por modulo"
   - 9
   - MOD-09 separado
   - MOD-03
 * - "Flujos de datos principales"
   - 9
   - MOD-09 separado
   - MOD-03

----

3. Contradiccion de numeracion
==============================

Documento "Identificando los modulos funcionales":

- Salto de MOD-04 a MOD-06.
- MOD-05 no existe (fusionado).
- RBAC_CORE es MOD-09.

Documento "Orden correcto de modulos":

- Numeracion consecutiva MOD-01 a MOD-09.
- RBAC_CORE es MOD-03.
- VIS_REPORTS es MOD-05.

----

4. Analisis de la contradiccion
===============================

Conclusion del analisis:

   "Los documentos posteriores ('Orden correcto', 'Analisis
   modulo por modulo', 'Flujos de datos') parecen haber
   IGNORADO la decision tomada en 'Identificando los modulos
   funcionales'."

Evidencia presentada:

1. "Identificando los modulos funcionales" decia explicitamente:
   "Resultado final: 8 modulos" y "SEC_RULES integrado como capa
   automatica, NO visible para usuarios".

2. Pero "Analisis modulo por modulo" (documento posterior segun
   UID) listaba 9 modulos con SEC_RULES separado.

----

5. Decision final consolidada (8 modulos)
=========================================

Justificacion:

1. La argumentacion tecnica mas solida estaba en "Identificando
   los modulos funcionales", "RBAC_CORE — Lo que el usuario ve"
   y "Aplicando ejemplos de Prompts".

2. ``SEC_RULES`` NO cumple la definicion de modulo funcional:

   - No tiene UI propia.
   - No tiene UC propios.
   - Es automatico (middleware/decoradores/policies).

3. La fusion de REPORTS + DASHBOARDS esta bien justificada.

5.1 Estructura final: 8 modulos funcionales
-------------------------------------------

::

   ARQ_MOD_001  AUTH              - Autenticacion y Sesiones
   ARQ_MOD_002  USER_IDENTITY     - Gestion de Identidades y Cuentas
   ARQ_MOD_003  RBAC_CORE         - Roles, Segmentos, Permisos + SEC_RULES (integrado)
   ARQ_MOD_004  ETL_MONITORING    - Supervision del ETL
   ARQ_MOD_005  VIS_REPORTS       - Visualizacion y Reportes
   ARQ_MOD_006  ALERTS            - Alertas y Notificaciones
   ARQ_MOD_007  AUDIT             - Auditoria Funcional
   ARQ_MOD_008  SYS_LOGS          - Bitacoras Tecnicas

5.2 Estructura interna de ARQ_MOD_003 RBAC_CORE
-----------------------------------------------

El modulo RBAC_CORE contiene DOS componentes documentados:

**Componente 1: RBAC_CORE (Administracion)**

- Tiene UI para administrar roles, segmentos, permisos.
- UC visibles: UC-010, UC-011, UC-041, UC-042, etc.
- Endpoints de API para CRUD de roles/permisos/segmentos.
- Es visible al usuario administrador.

**Componente 2: SEC_RULES (Enforcement Interno)**

- NO tiene UI.
- NO tiene UC propios.
- Es middleware/decoradores/policies.
- Se ejecuta automaticamente en cada request.
- Aplica restricciones: NO email, BD IVR readonly, limites
  exportacion, SoD, throttling, etc.

----

6. Enforcers integrados en SEC_RULES
====================================

.. list-table::
 :header-rows: 1
 :widths: 30 50 20

 * - Enforcer
   - Restriccion que aplica
   - CNST relacionada
 * - NoEmailEnforcer
   - Todo por buzon interno
   - CNST_001
 * - ReadOnlyIVREnforcer
   - BD IVR solo SELECT
   - CNST_003 / CNST-007 vigente
 * - NoRealTimeEnforcer
   - Sin WebSockets/SSE
   - CNST_003 vigente
 * - SessionDBEnforcer
   - Sesiones en BD, no Redis
   - CNST_002 / CNST-003 vigente
 * - ExportLimitEnforcer
   - Limites de registros por tipo
   - CNST_007 vigente
 * - ThrottlingEnforcer
   - Rate limiting
   - CNST_007 / CNST-011 vigente
 * - SoDEnforcer
   - Roles incompatibles
   - CNST_005 / **CNST-030 vigente**

----

7. Mapeo enforcers -> CNSTs vigentes
====================================

Los CNSTs citados en el documento original usan numeracion
legacy (CNST_001, CNST_002, CNST_003, CNST_005, CNST_007). En
el corpus vigente la numeracion canonica es CNST-001..033.
Mapeo aproximado para SEC_RULES enforcers:

- ``CNST_001`` -> :doc:`/normativa/restricciones/cnst-001-prohibicion-de-email-y-smtp`
- ``CNST_002`` -> :doc:`/normativa/restricciones/cnst-003-sesiones-persistidas-en-base-de-datos`
- ``CNST_003`` -> :doc:`/normativa/restricciones/cnst-007-base-de-datos-ivr-es-solo-lectura`
- ``CNST_005`` -> :doc:`/normativa/restricciones/cnst-030-reglas-de-separacion-de-funciones-sod`
- ``CNST_007`` -> :doc:`/normativa/restricciones/cnst-011-throttling-obligatorio-en-endpoints-publicos`

----

8. Cierre y trazabilidad
========================

**Documento original:**
``temp-holding/GENERACION_DOCUMENTACION/TMP_COMPLETO_IACT_2026-01-13_2/ANALISIS_PROFUNDO_DECISIONES_MODULOS_IACT_v2.rst``
(no publicado).

**Materializacion vigente de la decision (8 modulos ARQ_MOD_001..008):**
:doc:`/arquitectura-tecnica/modulos/index`.

**Cada ARQ_MOD individual:**

- :doc:`/arquitectura-tecnica/modulos/arq-mod-001-auth`
- :doc:`/arquitectura-tecnica/modulos/arq-mod-002-user-identity`
- :doc:`/arquitectura-tecnica/modulos/arq-mod-003-rbac-core`
- :doc:`/arquitectura-tecnica/modulos/arq-mod-004-etl-monitoring`
- :doc:`/arquitectura-tecnica/modulos/arq-mod-005-vis-reports`
- :doc:`/arquitectura-tecnica/modulos/arq-mod-006-alerts`
- :doc:`/arquitectura-tecnica/modulos/arq-mod-007-audit`
- :doc:`/arquitectura-tecnica/modulos/arq-mod-008-sys-logs`

**Modelo conceptual RBAC vigente:**
:doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`.
