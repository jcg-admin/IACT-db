```yml
created_at: 2026-05-01 03:29:03
project: IACT-docs
work_package: 2026-05-01-03-29-03-uc-corrections-against-canonical-model
phase: Phase 3 — ANALYZE (registered late)
author: NestorMonroy
status: Aprobado
version: 1.0.0
language: es
```

# Decisions Log — Corrección de los 61 UCs

Registro consolidado de TODAS las decisiones
tomadas autónomamente durante el WP, expandiendo
las 8 DEC estratégicas de
``track/lessons-learned.md`` con las decisiones
operativas (per-UC, per-edit) que vivían sólo en
commits.

## A. Decisiones estratégicas (DEC-01..DEC-08)

Ya documentadas en ``track/lessons-learned.md``.
Resumen:

- **DEC-01** — Política Segmento → AGR.
- **DEC-02** — Rename ~19 funciones a inglés v5.4.0.
- **DEC-03** — Patrón ``Clase de Dominio`` uniforme.
- **DEC-04** — UC_ACC_07 → UC_ACC_04 en uc-usr-01.
- **DEC-05** — Constraints en versiones vigentes.
- **DEC-06** — PERM como vista técnica del RBAC.
- **DEC-07** — Build incremental por cluster.
- **DEC-08** — BR-USR-04 re-semantizado.

## B. Mapeo UC → Clase de Dominio (61 decisiones)

Cada UC recibió una decisión explícita sobre qué
clase es primaria y cuáles secundarias. Tabla
completa (referencia para auditoría futura):

### B.1 AUTH (5)

| UC | Clase primaria | Clases secundarias | Justificación |
|----|----------------|---------------------|---------------|
| UC_AUTH_01 | Session | User, AuditEvent | Iniciar sesión crea Session; lee User; emite AuditEvent |
| UC_AUTH_02 | Session | AuditEvent | Cerrar sesión transita Session.state → CLOSED |
| UC_AUTH_03 | User | InternalMailbox, AuditEvent | Recuperar contraseña modifica User; entrega via InternalMailbox |
| UC_AUTH_04 | User | AuditEvent | Cambiar contraseña modifica User |
| UC_AUTH_05 | Session | User, AuditEvent | Admin gestiona Sessions (close_all) |

### B.2 USR (4)

| UC | Clase primaria | Clases secundarias | Justificación |
|----|----------------|---------------------|---------------|
| UC_USR_01 | User | Assignment, AccessGroup, AuditEvent | Crear User + opcional Assignment a AccessGroup |
| UC_USR_02 | User | Assignment, AccessGroup | Filtro por agrupador requiere joins |
| UC_USR_03 | User | Session, AuditEvent | Modificar User puede invalidar Sessions |
| UC_USR_04 | User | Session, AuditEvent | Deactivate User invalida sus Sessions |

### B.3 ACC (7)

| UC | Clase primaria | Clases secundarias | Justificación |
|----|----------------|---------------------|---------------|
| UC_ACC_01 | Assignment | Function, User, AuditEvent | Asignar función crea Assignment User-Function |
| UC_ACC_02 | Assignment | Function, User, AuditEvent | Revocar función transita Assignment.state → REVOKED |
| UC_ACC_03 | Assignment | Function, User | Consultar permisos itera Assignment del User |
| UC_ACC_04 | Assignment | AccessGroup, User, AuditEvent | Asignar AGR crea Assignment User-AccessGroup |
| UC_ACC_05 | SeparationRule | Function, AuditEvent | Gestión de SoD opera sobre SeparationRule |
| UC_ACC_08 | ExceptionalPermission | User, Function, AuditEvent | Permiso temporal (CNST-031) |
| UC_ACC_09 | AuditEvent | User, Assignment | Auditoría es lectura sobre AuditEvent |

### B.4 PERM (10) — todos Cat 5 vista técnica

| UC | Clase primaria | Clases secundarias | RBAC backing |
|----|----------------|---------------------|--------------|
| UC_PERM_01 | Assignment | FunctionGroup, User, AuditEvent | ACC-004 |
| UC_PERM_02 | Assignment | FunctionGroup, AuditEvent | ACC-008 |
| UC_PERM_03 | ExceptionalPermission | User, Function, AuditEvent | ACC-009 |
| UC_PERM_04 | ExceptionalPermission | AuditEvent | ACC-010 |
| UC_PERM_05 | FunctionGroup | AuditEvent | ACC-006 |
| UC_PERM_06 | FunctionGroup | Function, AuditEvent | ACC-007 |
| UC_PERM_07 | Assignment | ExceptionalPermission, User, Function | ACC-003 |
| UC_PERM_08 | Assignment | Function | CNST-032 (SQL get_user_menu) |
| UC_PERM_09 | AuditEvent | — | AUD-001 |
| UC_PERM_10 | AuditEvent | — | AUD-002 |

### B.5 RPT (15)

| UC | Clase primaria | Clases secundarias |
|----|----------------|---------------------|
| UC_RPT_01 | Report (scope=GENERAL) | Metric, Call |
| UC_RPT_02 | Report | Metric |
| UC_RPT_03 | Report | Metric, Call |
| UC_RPT_04 | ExportJob | Report, AuditEvent |
| UC_RPT_07 | ScheduledReport | Report, InternalMailbox, AuditEvent |
| UC_RPT_08 | ScheduledReport | Report |
| UC_RPT_09 | Report (operación filter) | — |
| UC_RPT_10 | SavedView | Report |
| UC_RPT_11 | Report (operación share) | InternalMailbox, AuditEvent |
| UC_RPT_12 | Report (scope=AGENTS) | Call |
| UC_RPT_13 | Report (scope=QUEUES) | Call |
| UC_RPT_14 | Report (scope=CAMPAIGNS) | Campaign, Call |
| UC_RPT_15 | Report (scope=TRANSFERENCES) | Call |
| UC_RPT_16 | Report (scope=IVR_MENUS) | Call |
| UC_RPT_17 | Report (scope=UNIQUE_CLIENTS) | Call |

### B.6 ALR (5)

| UC | Clase primaria | Clases secundarias |
|----|----------------|---------------------|
| UC_ALR_01 | Threshold | Metric |
| UC_ALR_02 | Alert | Threshold |
| UC_ALR_03 | Alert (state ACK) | AuditEvent |
| UC_ALR_04 | Alert | AuditEvent |
| UC_ALR_05 | Subscription | Alert, User, InternalMailbox |

### B.7 PIP (4)

| UC | Clase primaria | Clases secundarias |
|----|----------------|---------------------|
| UC_PIP_01 | ETLExecution | — |
| UC_PIP_02 | ETLError | ETLExecution |
| UC_PIP_03 | ETLExecution (lectura status) | — |
| UC_PIP_04 | ETLExecution (op retry) | AuditEvent |

### B.8 AUD (4)

| UC | Clase primaria | Clases secundarias |
|----|----------------|---------------------|
| UC_AUD_01 | AuditEvent | — |
| UC_AUD_02 | AuditEvent | — |
| UC_AUD_03 | AuditEvent | ExportJob |
| UC_AUD_04 | AuditEvent | — |

### B.9 LOG (7)

| UC | Clase primaria | Clases secundarias |
|----|----------------|---------------------|
| UC_LOG_01 | ApplicationLog | — |
| UC_LOG_02 | ETLLog | ETLExecution |
| UC_LOG_03 | ApplicationLog (op search) | — |
| UC_LOG_04 | ApplicationLog | ExportJob |
| UC_LOG_05 | InfrastructureLog | — |
| UC_LOG_06 | SystemHealth | — |
| UC_LOG_07 | TechnicalMetric | — |

## C. Decisiones de renombrado (~19 funciones)

Tabla completa de renombrados aplicados — cada
uno cita su origen Z.

| Antes (corpus) | Después (canónico v5.4.0) | Origen de la decisión |
|---------------|---------------------------|----------------------|
| ``manage_sessions`` | ``view_own_sessions`` | Z.2 D-01 (SRP scope propio) |
| ``view_active_sessions`` | ``view_all_active_sessions`` | Z.2 D-01 (SRP scope sistema) |
| ``delete_users`` | ``deactivate_users`` | Z.2 D-01 (BR-009 global) |
| ``crea_usuarios`` | ``create_users`` | Z.1.C (inglés) |
| ``asigna_funciones`` | ``assign_functions`` | Z.1.C (inglés) |
| ``revoca_funciones`` | ``revoke_functions`` | Z.1.C (inglés) |
| ``ve_asignaciones`` | ``view_assignments`` | Z.1.C (inglés) |
| ``asigna_agrupadores`` | ``assign_function_groups`` | Z.1.C (inglés + completo) |
| ``gestiona_sod`` | ``view_separation_rules`` | Z.2 D-01 (SRP) |
| ``ve_estado_etl`` | ``view_etl_executions`` | Z.1.C (inglés) |
| ``ve_errores_etl`` | ``view_etl_errors`` | Z.1.C (inglés) |
| ``ve_disponibilidad_datos`` | ``check_availability`` | Z.1.C + verbo "check" |
| ``solicita_reintento_etl`` | ``request_retry`` | Z.1.C (inglés + simple) |
| ``consulta_auditoria`` | ``view_audit_log`` | Z.1.C (inglés) |
| ``busca_auditoria`` | ``search_audit_log`` | Z.1.C (inglés) |
| ``exporta_auditoria`` | ``export_audit_log`` | Z.1.C (inglés) |
| ``genera_compliance`` | ``generate_compliance_report`` | Z.1.C (inglés + completo) |
| ``consulta_logs_sistema`` | ``view_application_logs`` | Z.2 D-05 (SRP rename) |
| ``ve_reportes`` | ``view_reports`` | Z.1.C (inglés) |

## D. Decisiones quirúrgicas (per-edit)

Ediciones puntuales dentro de UCs específicos —
catálogo completo:

### D.1 uc-usr-01 (heaviest)

- **D.1.a Eliminar EX-03 "Segmento No Valido"**
  → renumerar 8.4 a 8.3 (Datos Inválidos).
  Justificación: el caso "segmento no válido"
  desaparece con el concepto.
- **D.1.b SQL INSERT** — remover ``segmento_id``
  de la lista de columnas.
- **D.1.c Diagrama de actividad** — remover dos
  pasos: ":Admin selecciona segmento;" y
  ":Asignar segmento;".
- **D.1.d Body POST /api/users** — remover
  ``segmento_id`` del payload.
- **D.1.e BR-USR-04** preservar el ID con nueva
  semántica "Agrupador Inicial Opcional"
  (DEC-08 expandido).
- **D.1.f CNST_029 nota** — remover el sufijo
  "Segmento obligatorio".
- **D.1.g UC Relacionados** — reemplazar
  UC_ACC_07 por UC_ACC_04 (DEC-04).

### D.2 uc-usr-02

- **D.2.a SQL JOIN** — cambiar
  ``JOIN segmentos s ON u.segmento_id = s.id``
  por
  ``LEFT JOIN user_access_groups uag + access_groups ag``.
- **D.2.b FA-02** — renombrar de "Filtrar por
  Segmento" a "Filtrar por Agrupador" + ajustar
  pasos de la sub-sección.

### D.3 uc-usr-03

- **D.3.a PUT /api/users payload** — reemplazar
  ``segmento_id`` por ``access_group_id``.
- **D.3.b SQL UPDATE** — remover
  ``segmento_id = ?`` y la coma trailing.

### D.4 uc-acc-03

- **D.4.a Sequence diagram** — remover bloque
  ``== Segmento ==`` con su SELECT JOIN
  segmentos.
- **D.4.b Response payload** — remover
  ``segmento`` del JSON de respuesta.
- **D.4.c Activity diagram** — remover
  ``:Consultar segmento;`` y ``end fork``.
- **D.4.d JSON example** — remover bloque
  ``"segmento": { "id":1, "nombre":"Centro Norte" }``.

### D.5 uc-acc-09

- **D.5.a EventType list** — remover el item
  ``SEGMENT_ASSIGN — Cambio de segmento`` del
  catálogo de eventos auditables.

### D.6 uc-rpt-04

- **D.6.a Restricciones** — actualizar versiones
  a vigentes: CNST-019 v3.0.0 (cola asíncrona
  abstracta), CNST-020 v3.0.0 (throttling
  abstracto), BR-011 v2.0.0 (límites delegados a
  CNST). Decisión: NO embed cifras concretas
  (stack y números viven en ADR de
  implementación per Z.2 D-08/D-09).
- **D.6.b Mantener** funciones RBAC backing
  separadas (RPT-004/005/006) — Larman dice 1 UC,
  SRP dice 3 funciones (Z.2 D-07).

### D.7 uc-rpt-15/16/17 + uc-log-05/06/07

- **D.7.a UCs Relacionados → UC Relacionados**
  — normalizar el label al singular usado por el
  resto del corpus (consistency).

### D.8 uc-pip-03

- **D.8.a Selección de fn name canónico** —
  ``check_availability`` (no
  ``view_etl_availability``). Justificación: el
  verbo "check" describe mejor la operación
  (resultado booleano + metadata) que "view".

## E. Decisiones de NO actuar (rejecciones)

Casos donde se decidió **no** modificar pese a
ser tentador:

- **E.1 No tocar** ``diagramas-uml.rst § 1``
  ejemplo de clase ``Llamada`` — es material
  pedagógico que muestra la estructura de un
  diagrama de clases. Mantener español como
  ejemplo didáctico. (Decisión derivada de
  Análisis 07 del WP predecesor.)
- **E.2 No restaurar** UC_ACC_06 / UC_ACC_07 —
  fueron eliminados por Z.1.C Camino C; la
  funcionalidad quedó cubierta por UC_ACC_04
  (asignar agrupador). Restaurarlos contradiría
  el cierre de Z.1.C.
- **E.3 No re-numerar BRs** después de eliminar
  o re-semantizar BR-USR-04. Justificación:
  preservar trazabilidad downstream (FRs,
  tests).
- **E.4 No mover SystemHealth y TechnicalMetric
  a un nuevo bounded context** "Monitoring"
  — decisión heredada del WP predecesor (H-A06)
  por cohesión de módulo.
- **E.5 No introducir superclase** ``ReportRequest``
  para ScheduledReport / ExportJob / SavedView
  — heredado del WP predecesor (H-A05) por
  abstracción prematura.
- **E.6 No tocar el código** Python en
  ``temp-holding/Modules/`` — el scope de este
  WP es la documentación RST, no el código.

## F. Decisiones de método

Aplican al WP entero:

- **F.1 Cluster como unidad de commit** — cada
  uno de los 9 clusters se commitea
  independientemente (DEC-07). Permite revert
  granular si un cluster introduce regresión.
- **F.2 Sed bulk + Edit surgical** — bulk
  ``sed`` para patrones repetitivos, ``Edit``
  con contexto para inserciones estructurales.
- **F.3 Build incremental como gate** —
  ``make html`` (sin ``make clean``) tras cada
  cluster antes de commitear.
- **F.4 Audit-then-act** —
  ``discover/uc-audit-matrix.md`` redactada
  ANTES de empezar a editar, mapea defectos por
  UC. Permitió priorizar y verificar
  exhaustividad al cierre.
- **F.5 Decisiones autónomas** — el ejecutor
  delegó decisiones para evitar pausa. Cada
  decisión documentada aquí o en
  ``lessons-learned.md`` o en el commit.

## Resumen cuantitativo

| Tipo de decisión | Cantidad |
|------------------|---------:|
| Estratégicas (DEC-01..DEC-08) | 8 |
| Mapeo UC → Clase (B) | 61 (2-4 clases por UC) |
| Renombrados de funciones (C) | 19 |
| Quirúrgicas / per-edit (D) | ~25 |
| De NO actuar (E) | 6 |
| De método (F) | 5 |
| **Total decisiones documentadas** | **124** |

## Trazabilidad

Cada decisión se ancla en:

- Una decisión heredada del programa Z (D-01..D-11)
  y/o Z.2.A § Cat 1..5; o
- Una directiva del ejecutor (autonomous loop /
  inglés / español / build incremental); o
- El modelo canónico ``modelo-dominio-iact.rst``
  v1.0.0; o
- Un análisis previo (Z.2.A genealogy, Análisis
  07 del WP predecesor).

Ningún paso de este WP fue una decisión sin
ancla — todas referencian a un artefacto
publicado o a una directiva escrita.
