.. meta::
 :artefacto: INDEX_ARQ_MODULOS
 :tipo: Indice
 :dominio: arquitectura_tecnica
 :subdominio: modulos
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Interno

=======================
Modulos Arquitectonicos
=======================

Definicion arquitectonica de los **8 modulos funcionales** del sistema
IACT. Cada ``ARQ_MOD_NNN`` documenta el proposito, responsabilidades,
componentes internos, interfaces, dependencias y consideraciones
tecnicas del modulo correspondiente.

Mapeo modulo ↔ casos de uso:

.. list-table::
 :widths: 25 50 25
 :header-rows: 1

 * - Modulo arquitectonico
   - UCs en requisitos
   - # UCs
 * - ARQ_MOD_001 AUTH
   - :doc:`/requisitos/casos-uso/auth/index`
   - 5
 * - ARQ_MOD_002 USER_IDENTITY
   - :doc:`/requisitos/casos-uso/users/index`
   - 4
 * - ARQ_MOD_003 RBAC_CORE
   - :doc:`/requisitos/casos-uso/access/index` + :doc:`/requisitos/casos-uso/permissions/index`
   - 19 (9 ACC + 10 PERM)
 * - ARQ_MOD_004 ETL_MONITORING
   - :doc:`/requisitos/casos-uso/pipeline/index`
   - 4
 * - ARQ_MOD_005 VIS_REPORTS
   - :doc:`/requisitos/casos-uso/reports/index`
   - 14
 * - ARQ_MOD_006 ALERTS
   - :doc:`/requisitos/casos-uso/alerts/index`
   - 5
 * - ARQ_MOD_007 AUDIT
   - :doc:`/requisitos/casos-uso/audit/index`
   - 4
 * - ARQ_MOD_008 SYS_LOGS
   - :doc:`/requisitos/casos-uso/logs/index`
   - 4

Catalogo
--------

.. toctree::
 :maxdepth: 1

 arq-mod-001-auth
 arq-mod-002-user-identity
 arq-mod-003-rbac-core
 arq-mod-004-etl-monitoring
 arq-mod-005-vis-reports
 arq-mod-006-alerts
 arq-mod-007-audit
 arq-mod-008-sys-logs
