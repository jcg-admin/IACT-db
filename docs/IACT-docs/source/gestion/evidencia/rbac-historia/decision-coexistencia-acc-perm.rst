.. meta::
 :artefacto: DECISION_COEXISTENCIA_ACC_PERM
 :tipo: Evidencia
 :dominio: gestion
 :subdominio: evidencia/rbac-historia
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==================================================
Decisión: Coexistencia ACC ↔ PERM (Hipótesis 1)
==================================================

.. note::

 Migrado a source/ desde artefacto histórico de WP
 source-rebuild-requisitos (Phase 1 DISCOVER — escenario
 arquitectónico). Aprobada por el ejecutor 2026-04-29.
 Aplica skill ``ba-elicitation``.

.. admonition:: Estatus

 **APROBADA por el ejecutor (2026-04-29).** El conteo de UCs es
 **evolutivo** — puede crecer (nuevos UCs identificados durante
 discovery) o decrecer (consolidación de overlaps). Los números
 documentados son **estado actual**, NO decisivos. La decisión
 arquitectónica que se fija es la **coexistencia ACC ↔ PERM**, no
 el conteo.

1. Premisa
==========

MOD_Access (catálogo cerrado del proyecto) y MOD_Permissions
(sistema técnico granular) **COEXISTEN**. Son dos vistas distintas
del mismo sistema RBAC plano
(:doc:`/normativa/restricciones/cnst-029-rbac-modelo-plano`):

- **MOD_Access** = vista funcional para admin no-tech (asignar
  agrupadores predefinidos AGR-001..010).
- **MOD_Permissions** = sistema técnico granular para admin tech
  (crear grupos dinámicos, asignar capacidades, runtime check,
  menú dinámico).

Ambos preservan todos sus UCs documentados. No hay pérdida.

2. Ventajas
===========

- **Cobertura máxima**: preserva los 49 UCs canónicos ``.rst`` +
  10 UC_PERM documentados.
- **Dos perfiles de usuario admin**:

  - Admin no-tech (RH, ops): usa UC_ACC con agrupadores fijos.
  - Admin tech (DevSecOps): usa UC_PERM granular cuando necesita
    crear grupos especiales.

- **Zero rework** sobre los ``.rst`` canónicos.
- **Compatibilidad con CNST_005** (18 roles fijos legacy) si se
  preserva.

3. Desventajas
==============

- **Doble vocabulario** en docs: "Función" (ACC) vs "Capacidad"
  (PERM), "Agrupador" (ACC) vs "Grupo de Permisos" (PERM).
- **Triple auditoría**: UC_ACC_09 + UC_PERM_09 + UC_AUD_01..04.
  Tres fuentes potenciales de verdad.
- **Sin ADR formal** (mitigado: se crea ADR-GOB-008).
- **Más UCs para mantener** (63 vs 54).

4. Catálogo modular completo
============================

4.1 Tabla maestra
-----------------

.. list-table::
 :widths: 20 30 25 25
 :header-rows: 1

 * - Módulo
   - UCs
   - Cantidad
   - Código origen
 * - MOD_Auth
   - UC_AUTH_01..05
   - 5
   - ``.rst`` canónico
 * - MOD_Users
   - UC_USR_01..04
   - 4
   - ``.rst`` canónico
 * - MOD_Access
   - UC_ACC_01..09
   - **9** (preservados intactos)
   - ``.rst`` canónico
 * - MOD_Permissions
   - UC_PERM_01..10
   - **10** (NUEVO módulo)
   - ``.md`` en gobernanza inputs
 * - MOD_Reports
   - UC_RPT_01..14
   - 14
   - ``.rst`` canónico
 * - MOD_Alerts
   - UC_ALR_01..05
   - 5
   - ``.rst`` canónico
 * - MOD_Pipeline
   - UC_PIP_01..04
   - 4
   - ``.rst`` canónico
 * - MOD_Audit
   - UC_AUD_01..04
   - 4
   - ``.rst`` canónico
 * - MOD_Logs
   - UC_LOG_01..04
   - 4
   - ``.rst`` canónico
 * - **TOTAL (estado actual)**
   -
   - **catálogo evolutivo**
   -

4.2 MOD_Auth — Autenticación y Sesiones (5 UCs)
-----------------------------------------------

UC_AUTH_01 Iniciar Sesión, UC_AUTH_02 Cerrar Sesión, UC_AUTH_03
Recuperar Contraseña, UC_AUTH_04 Cambiar Contraseña, UC_AUTH_05
Gestionar Sesiones.

CNSTs: CNST_001 (no email), CNST_002-005 (sesiones BD/única/timeout),
CNST_009 (auth DRF), CNST_011 (throttling).

4.3 MOD_Users — Gestión de Identidades (4 UCs)
----------------------------------------------

UC_USR_01..04 (Crear, Consultar, Modificar, Eliminar Usuario).

CNSTs: CNST_026 (no PII en logs), CNST_027 (clasificación datos).

4.4 MOD_Access — Roles, Permisos, Segmentos (9 UCs preservados)
---------------------------------------------------------------

UC_ACC_01 Asignar Funciones (atómicas), UC_ACC_02 Revocar
Funciones, UC_ACC_03 Consultar Permisos, UC_ACC_04 Asignar
Agrupador (AGR-001..010), UC_ACC_05 Gestionar SoD, UC_ACC_06
Gestionar Segmentos, UC_ACC_07 Asignar Segmento, UC_ACC_08 Permiso
Temporal, UC_ACC_09 Auditar Cambios Acceso.

CNSTs: CNST_029 (RBAC plano), CNST_030 (SoD), CNST_031 (permisos
temporales 6 meses).

**Vocabulario:** Función (atomic capability), Agrupador (rol
predefinido AGR-001..010 fijo), Segmento (data scope).

4.5 MOD_Permissions — Sistema PERM Granular (10 UCs NUEVO)
----------------------------------------------------------

UC_PERM_01 Asignar Grupo, UC_PERM_02 Revocar Grupo, UC_PERM_03
Conceder Permiso Excepcional, UC_PERM_04 Revocar Permiso
Excepcional, UC_PERM_05 Crear Grupo, UC_PERM_06 Asignar Capacidades,
UC_PERM_07 Verificar Permiso, UC_PERM_08 Generar Menú Dinámico,
UC_PERM_09 Auditar Acceso, UC_PERM_10 Consultar Auditoría.

CNSTs: CNST_029 (RBAC plano — mismo CNST que ACC), CNST_031
(permisos temporales).

**Vocabulario:** Capacidad (granular), GrupoPermiso (set creable),
PermisoExcepcional (one-off override).

**Implementación backend:** 8 modelos Django + 5 funciones SQL
nativas + endpoint ``/menu/`` (estado documentado en GAP_ANALYSIS).

4.6 MOD_Reports — Dashboards y Reportes (14 UCs)
------------------------------------------------

UC_RPT_01 Ver Dashboard, UC_RPT_02 Ver Métricas Tiempo Real,
UC_RPT_03 Ver Reportes Históricos, UC_RPT_04..06 Exportar
(CSV/Excel/PDF), UC_RPT_07 Programar Reporte, UC_RPT_08 Ver
Programados, UC_RPT_09 Configurar Filtros, UC_RPT_10 Guardar
Vista, UC_RPT_11 Compartir Reporte, UC_RPT_12 Reporte Agentes,
UC_RPT_13 Reporte Colas, UC_RPT_14 Reporte Campañas.

CNSTs: CNST_017 (SLA tiempos), CNST_018 (rango max 2 años),
CNST_019 (export async > 10k), CNST_020 (throttling).

4.7 MOD_Alerts — Alertas y Notificaciones (5 UCs)
-------------------------------------------------

UC_ALR_01 Configurar Umbrales, UC_ALR_02 Ver Activas, UC_ALR_03
Reconocer, UC_ALR_04 Ver Historial, UC_ALR_05 Gestionar
Suscripciones.

CNSTs: CNST_001 (no email), CNST_002 (buzón interno).

4.8 MOD_Pipeline — Supervisión ETL (4 UCs)
------------------------------------------

UC_PIP_01..04 (Supervisar, Consultar Errores, Consultar
Disponibilidad, Solicitar Reintento).

CNSTs: CNST_006 (BD dual), CNST_007 (IVR readonly), CNST_008
(ETL ventana 6-12h).

4.9 MOD_Audit — Auditoría Funcional (4 UCs)
-------------------------------------------

UC_AUD_01..04 (Consultar, Buscar, Exportar, Reporte Compliance).

CNSTs: CNST_025 (auditoría inmutable), CNST_026 (no PII en logs).

**Convive con UC_PERM_09/10** — auditoría de permisos granular en
PERM, auditoría sistema general en AUD.

4.10 MOD_Logs — Bitácoras Técnicas (4 UCs)
------------------------------------------

UC_LOG_01..04 (Consultar Sistema, Consultar ETL, Buscar, Exportar).

CNSTs: CNST_024 (logs JSON), CNST_026 (no PII).

5. Mapeo de auditoría (3 fuentes)
=================================

.. list-table::
 :widths: 35 65
 :header-rows: 1

 * - UC
   - Foco
 * - UC_ACC_09 Auditar Cambios Acceso
   - Cambios de asignación funciones/agrupadores/segmentos
 * - UC_PERM_09 Auditar Acceso
   - Cada acceso runtime (verificación de permiso)
 * - UC_PERM_10 Consultar Auditoría de Permisos
   - Vista admin de logs PERM
 * - UC_AUD_01 Consultar Auditoría
   - Vista general sistema
 * - UC_AUD_02..04
   - Buscar, Exportar, Reporte Compliance

**3 fuentes** — riesgo de divergencia mitigado con NFR_AUD_01
(cada acción sensible registra evento ÚNICO en AuditLog).

6. Tareas Phase 2 EXECUTE (Hipótesis 1)
=======================================

.. list-table::
 :widths: 8 50 25 17
 :header-rows: 1

 * - #
   - Tarea
   - Insumo
   - Esfuerzo
 * - T-1
   - Copiar 49 RST canónicos a
     ``source/requisitos/casos-uso/``
   - ``temp-backup/.../casos_uso/``
   - Bajo
 * - T-2
   - Convertir 10 UC_PERM ``.md`` → ``.rst`` con metadata estándar
   - ``inputs/canonical/UC-PERM-*.md``
   - Medio (1894 ln)
 * - T-3
   - Mapear refs CNST legacy → SRP-31 en metadata UC
   - inventory + mapping doc
   - Medio
 * - T-4
   - Crear 9 ``index.rst`` por módulo + ``index.rst`` raíz
   - nuevo
   - Bajo
 * - T-5
   - Conectar a ``source/requisitos/index.rst`` padre
   - nuevo
   - Bajo
 * - T-6
   - Crear ADR-GOB-008 declarando coexistencia ACC ↔ PERM
   - nuevo
   - Bajo
 * - T-7
   - Build limpio + verificación automatizada
   -
   - Bajo

**Esfuerzo total estimado:** 4-6 horas.

7. Decisiones D-REQ derivadas
=============================

- **D-REQ-1**: Confirmar coexistencia (Hipótesis 1).
- **D-REQ-2**: UC_PERM_NN (2-dig) vs UC_PERM_NNN (3-dig) —
  sugerido 2-dig para consistencia.
- **D-REQ-3**: UC_AUD_04 vs UC_PERM_10 — ambos coexisten con foco
  distinto.
- **D-REQ-4**: Crear ADR-GOB-008 que declare la decisión.

8. Vista del directorio resultante
==================================

::

 source/requisitos/casos-uso/
 ├── index.rst
 ├── auth/         (5 UCs + index)
 ├── users/        (4 UCs + index)
 ├── access/       (9 UCs + index) — agrupadores fijos
 ├── permissions/  (10 UCs + index) — grupos creables [NUEVO]
 ├── reports/      (14 UCs + index)
 ├── alerts/       (5 UCs + index)
 ├── pipeline/     (4 UCs + index)
 ├── audit/        (4 UCs + index)
 └── logs/         (4 UCs + index)

9. Riesgos a mitigar
====================

1. **Drift de vocabulario** — agregar glosario en
   :doc:`/base-cognitiva/glosario` aclarando: Función (atomic),
   Capacidad (granular), Agrupador (predefined fixed), GrupoPermiso
   (creable).
2. **Triple auditoría** — declarar en cada UC su FUENTE DE VERDAD
   (referenciar al UC apropiado, no duplicar).
3. **Confusión para nuevos desarrolladores** — documentar en
   ADR-GOB-008 cuándo usar ACC vs PERM.

10. Trazabilidad
================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``ba-elicitation`` (BABOK — Elicitation)
 * - **WP origen**
   - source-rebuild-requisitos (2026-04-28)
 * - **Migrado a source**
   - 2026-04-30 (sub-WP md-references-audit)
 * - **ADR canónico**
   - :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`
 * - **Formalización derivada**
   - :doc:`formalizacion-modelo-rbac`
