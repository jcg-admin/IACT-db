```yml
created_at: 2026-04-28 22:30:00
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inventario FR — Filtro IACT real y nomenclatura v4.0.0

Este artefacto filtra los 315 IDs FR detectados en `id-index-fr.md` para
identificar solo los del dominio IACT (call center analytics) y documenta
la nomenclatura v4.0.0 declarada en el Plan Maestro.

## Catalogo v4.0.0 detectado

**Patron oficial v4.0.0** (declarado en
`inputs/canonical/PLAN_MAESTRO_FR_NFR_v1_0_0_borrador.md`, secciones 2.1
y 3.3):

```
FR_[MOD]_[UC]_[NN]_[Nombre_Descriptivo]
```

- MOD: AUTH | USR | ACC | PIP | RPT | ALR | AUD | LOG (8 modulos)
- UC: numero del UC origen (01-NN dentro del modulo)
- NN: secuencial del FR dentro del UC (01-99)

**Nomenclaturas legacy coexistentes en el repo (3 detectadas):**

| Nomenclatura | Ejemplo | Origen | Estado |
|---|---|---|---|
| Numerica con sub-id | `FR-001.01` (Validar formato username) | 48 archivos `.rst` en `inputs/canonical/` (auth/users/access) | Vigente, listos para migrar |
| Modular sin UC | `FR-ACC-001`, `FR-AUTH-007`, `FR-ALR-001`, `FR-AUD-001` | Tablas en `requisitos/` | Vigente, parcial |
| Modular completa v4.0.0 | `FR_AUTH_01_05`, `FR_ACC_05_02`, `FR_RPT_07_03` | Mencionada en Plan Maestro y referencias | **Objetivo de migracion** |

**Mapping legacy -> v4.0.0** (no formalizado en tabla unica, pero
inferible de los archivos `.rst` existentes y del Plan Maestro seccion
7.2):

| Legacy `.rst` (file)            | UC origen     | v4.0.0 esperado          |
|---------------------------------|---------------|--------------------------|
| FR-001.01..05                    | UC_AUTH_01    | FR_AUTH_01_01..05        |
| FR-002.01..03                    | UC_AUTH_02    | FR_AUTH_02_01..03        |
| FR-003.01..05                    | UC_AUTH_03    | FR_AUTH_03_01..05        |
| FR-004.01..04                    | UC_AUTH_04    | FR_AUTH_04_01..04        |
| FR-005.01..04                    | UC_AUTH_05    | FR_AUTH_05_01..04        |
| FR-006.01..05                    | UC_USR_01     | FR_USR_01_01..05         |
| FR-007.01..04                    | UC_USR_02     | FR_USR_02_01..04         |
| FR-008.01..04                    | UC_USR_03     | FR_USR_03_01..04         |
| FR-009.01..04                    | UC_USR_04     | FR_USR_04_01..04         |
| FR-010.01..04                    | UC_ACC_01     | FR_ACC_01_01..04         |
| FR-011.01..03                    | UC_ACC_02     | FR_ACC_02_01..03         |

(48 archivos `.rst` en `inputs/canonical/` confirmados via `ls`.)

## FRs IACT reales (max 60)

Los siguientes 51 FR estan respaldados por archivo `.rst` canonico
(PROVEN) o por entrada explicita en `id-index-fr.md` con contexto IACT
verificable. Agrupados por modulo / UC.

### MOD_AUTH (UC_AUTH_01..05) — 21 FR

| Legacy | v4.0.0 | Titulo | UC | Tipo | BR | Criterio resumido |
|--------|--------|--------|----|------|----|-------------------|
| FR-001.01 | FR_AUTH_01_01 | Validar formato username | UC_AUTH_01 | Validacion | BR_013 | username regex valido, no vacio |
| FR-001.02 | FR_AUTH_01_02 | Validar credenciales | UC_AUTH_01 | Proceso | BR_006 | hash bcrypt match en tabla users |
| FR-001.03 | FR_AUTH_01_03 | Generar token JWT | UC_AUTH_01 | Proceso | BR_005 | exp 8h, claims firmados |
| FR-001.04 | FR_AUTH_01_04 | Invalidar sesiones previas | UC_AUTH_01 | Proceso | BR_005 | sesion unica por usuario |
| FR-001.05 | FR_AUTH_01_05 | Registrar evento auditoria | UC_AUTH_01 | Auditoria | BR_008 | LOGIN_SUCCESS en user_action_log |
| FR-002.01 | FR_AUTH_02_01 | Invalidar token JWT | UC_AUTH_02 | Proceso | BR_005 | token blacklisted hasta exp |
| FR-002.02 | FR_AUTH_02_02 | Registrar evento logout | UC_AUTH_02 | Auditoria | BR_008 | LOGOUT en user_action_log |
| FR-002.03 | FR_AUTH_02_03 | Limpiar datos sesion cliente | UC_AUTH_02 | Interfaz | — | localStorage purgado |
| FR-003.01 | FR_AUTH_03_01 | Validar username existe | UC_AUTH_03 | Validacion | BR_013 | username en BD activo |
| FR-003.02 | FR_AUTH_03_02 | Mostrar pregunta seguridad | UC_AUTH_03 | Interfaz | — | render question del perfil |
| FR-003.03 | FR_AUTH_03_03 | Validar respuesta | UC_AUTH_03 | Validacion | — | hash respuesta match |
| FR-003.04 | FR_AUTH_03_04 | Generar password temporal | UC_AUTH_03 | Proceso | — | password aleatorio + expira 24h |
| FR-003.05 | FR_AUTH_03_05 | Forzar cambio siguiente login | UC_AUTH_03 | Persistencia | — | flag must_change_password=true |
| FR-004.01 | FR_AUTH_04_01 | Validar password actual | UC_AUTH_04 | Validacion | — | hash actual coincide |
| FR-004.02 | FR_AUTH_04_02 | Validar complejidad nuevo password | UC_AUTH_04 | Validacion | BR_006 | min 8 ch, mayus, num, simbolo |
| FR-004.03 | FR_AUTH_04_03 | Actualizar hash BD | UC_AUTH_04 | Persistencia | — | bcrypt cost 12 |
| FR-004.04 | FR_AUTH_04_04 | Invalidar sesiones | UC_AUTH_04 | Proceso | BR_005 | sesiones activas eliminadas |
| FR-005.01 | FR_AUTH_05_01 | Listar sesiones activas | UC_AUTH_05 | UI | — | tabla con device, ip, last_seen |
| FR-005.02 | FR_AUTH_05_02 | Mostrar detalle sesion | UC_AUTH_05 | UI | — | drawer con metadata sesion |
| FR-005.03 | FR_AUTH_05_03 | Invalidar sesion individual | UC_AUTH_05 | Proceso | BR_005 | revocar token by session_id |
| FR-005.04 | FR_AUTH_05_04 | Invalidar sesiones por usuario | UC_AUTH_05 | Proceso | BR_005 | revocar todos tokens del usuario |

### MOD_USR (UC_USR_01..04) — 17 FR

| Legacy | v4.0.0 | Titulo | UC | Tipo | BR | Criterio resumido |
|--------|--------|--------|----|------|----|-------------------|
| FR-006.01 | FR_USR_01_01 | Validar campos obligatorios | UC_USR_01 | Validacion | BR_013 | username, email, segmento req. |
| FR-006.02 | FR_USR_01_02 | Verificar unicidad username | UC_USR_01 | Validacion | BR_013 | no existe en users |
| FR-006.03 | FR_USR_01_03 | Generar password temporal | UC_USR_01 | Proceso | — | password 12 ch, expira 24h |
| FR-006.04 | FR_USR_01_04 | Crear registro usuario | UC_USR_01 | Persistencia | BR_012 | INSERT users + segmento |
| FR-006.05 | FR_USR_01_05 | Registrar auditoria | UC_USR_01 | Auditoria | BR_008 | USER_CREATED en log |
| FR-007.01 | FR_USR_02_01 | Cargar datos usuario | UC_USR_02 | Proceso | — | SELECT por user_id |
| FR-007.02 | FR_USR_02_02 | Validar campos modificados | UC_USR_02 | Validacion | BR_013 | re-validar email, segmento |
| FR-007.03 | FR_USR_02_03 | Actualizar registro | UC_USR_02 | Persistencia | — | UPDATE users con diff |
| FR-007.04 | FR_USR_02_04 | Registrar cambios auditoria | UC_USR_02 | Auditoria | BR_008 | USER_UPDATED + diff |
| FR-008.01 | FR_USR_03_01 | Validar usuario activo | UC_USR_03 | Validacion | BR_009 | is_active=true antes de baja |
| FR-008.02 | FR_USR_03_02 | Cambiar estado INACTIVO | UC_USR_03 | Persistencia | BR_009 | soft delete (is_active=false) |
| FR-008.03 | FR_USR_03_03 | Invalidar sesiones | UC_USR_03 | Proceso | BR_005 | logout forzado |
| FR-008.04 | FR_USR_03_04 | Preservar registro historico | UC_USR_03 | Persistencia | BR_009 | NO DELETE fisico |
| FR-009.01 | FR_USR_04_01 | Obtener lista paginada | UC_USR_04 | Proceso | — | LIMIT/OFFSET, page_size 25 |
| FR-009.02 | FR_USR_04_02 | Aplicar filtros | UC_USR_04 | Proceso | — | filtros por estado, segmento |
| FR-009.03 | FR_USR_04_03 | Ordenar resultados | UC_USR_04 | Proceso | — | sort by username/created_at |
| FR-009.04 | FR_USR_04_04 | Mostrar indicador inactividad | UC_USR_04 | UI | BR_003 | badge "inactivo 90d" |

### MOD_ACC (UC_ACC_01..02 confirmados) — 7 FR canonicos

| Legacy | v4.0.0 | Titulo | UC | Tipo | BR | Criterio resumido |
|--------|--------|--------|----|------|----|-------------------|
| FR-010.01 | FR_ACC_01_01 | Listar funciones disponibles | UC_ACC_01 | Proceso | BR_006 | catalogo NIST RBAC flat |
| FR-010.02 | FR_ACC_01_02 | Validar SoD antes asignar | UC_ACC_01 | Validacion | BR_007 | bloquea conflictos SoD |
| FR-010.03 | FR_ACC_01_03 | Crear asignacion usuario-funcion | UC_ACC_01 | Persistencia | BR_006 | INSERT user_function |
| FR-010.04 | FR_ACC_01_04 | Calcular permisos efectivos | UC_ACC_01 | Calculo | BR_006 | union de funciones activas |
| FR-011.01 | FR_ACC_02_01 | Listar funciones asignadas | UC_ACC_02 | Proceso | BR_006 | SELECT user_function por user |
| FR-011.02 | FR_ACC_02_02 | Eliminar asignacion | UC_ACC_02 | Persistencia | BR_006 | DELETE user_function |
| FR-011.03 | FR_ACC_02_03 | Recalcular permisos efectivos | UC_ACC_02 | Calculo | BR_006 | refresh cache permisos |

### MOD_RPT, MOD_PIP, MOD_ALR, MOD_AUD, MOD_LOG — referencias detectadas (sin .rst aun)

Detectados en `id-index-fr.md` con contexto IACT, sin archivo canonico.
v4.0.0 inferido del Plan Maestro seccion 6.2 (estructura). 6 FR sample
para confirmar dominio IACT (no exhaustivo — Plan Maestro estima ~330
adicionales pendientes de generar):

| Legacy | v4.0.0 esperado | Titulo | UC | Tipo |
|--------|-----------------|--------|----|------|
| FR-018.01 | FR_RPT_NN_NN | Listar metricas disponibles | UC_RPT_* | UI |
| FR-019.01 | FR_RPT_13_01 | Crear programacion | UC_RPT_13 | Persistencia |
| FR-022.01 | FR_RPT_10_01 | Validar limite registros | UC_RPT_10 | Validacion |
| FR-036.01 | FR_ALR_01_01 | Listar metricas alertables | UC_ALR_01 | UI |
| FR-037.01 | FR_ALR_01_NN | Depositar en buzon interno | UC_ALR_01 | Integracion |
| FR-051.01 | FR_PIP_02_01 | Listar ejecuciones con error | UC_PIP_02 | Proceso |

**Total documentado: 51 FR IACT reales** (45 con `.rst` canonico + 6
referencias). Por debajo del cap de 60 — el resto de FRs estimados
(~341 segun Plan Maestro) aun no existen como artefactos y no son
inventariables aqui.

## FRs pedagogicos descartados

IDs detectados en `id-index-fr.md` cuyo contexto sample remite al dominio
pedagogico (productos quimicos, MSDS, presupuestos, citas, ajedrez,
TikTok, SAP, peligrosidad CAS) — no aplican a IACT call center
analytics:

- `FR-040` (1231 apariciones — "validar formato CAS")
- `FR-041` ("Mostrar disponibilidad en listado de productos")
- `FR-042` ("Actualizar stock_actual despues de entrega")
- `FR-044` ("Eliminar Producto Soft Delete")
- `FR-061` ("Query de solicitudes")
- `FR-063` ("Consultar disponibilidad")
- `FR-090` ("Consultar inventario")
- `FR-099`, `FR-999` (TikTok — anti-ejemplos)
- `FR-101` ("Consultar catalogo")
- `FR-110`, `FR-112`, `FR-115` (passwords pedagogicos — duplican AUTH)
- `FR-150`, `FR-160` (Dashboard/Busqueda pedagogicos)
- `FR-200`, `FR-204` (citas + clase_peligrosidad)
- `FR-205` a `FR-214` (aprobacion lote, SAP, presupuesto, certificacion)
- `FR-220` (analisis tendencias pedagogico)
- `FR-250`, `FR-300` (ejemplos didacticos)
- `FR-301`..`FR-309` (UC pedagogico — duplican notificaciones IACT)
- `FR-401`..`FR-409` (ejemplos BR-087)
- `FR-500` ("busqueda por titulo")
- `FR-601`, `FR-602`, `FR-604` (score/cobertura pedagogicos)
- `FR-888` (anti-ejemplo "ajedrez")
- `FR-901`..`FR-909` (UC pedagogico permisos temporales)

Tambien descartadas las series intermedias `FR-016`, `FR-031..035`,
`FR-060`, `FR-070..073`, `FR-211..214` que aparecen como tablas
pedagogicas sin archivo canonico ni vinculacion a UC IACT verificable.

## Hallazgos

**H-01 — Triple nomenclatura coexistente (CRITICO).** El repo contiene
tres patrones FR vivos: `FR-NNN.NN` (48 .rst canonicos, auth/users/access),
`FR-MOD-NNN` (tablas en requisitos sin .rst) y `FR_MOD_UC_NN` (objetivo
v4.0.0). La inconsistencia bloquea trazabilidad UC->FR a escala.

**H-02 — Mapping legacy->v4.0.0 NO formalizado.** El Plan Maestro define
v4.0.0 (seccion 2.1) pero no incluye una tabla unica de equivalencia
para los 48 .rst legacy. El mapping queda inferible pero no auditable.
Recomendacion: crear `analyze/mapping-fr-legacy-to-v4.md` con tabla
exhaustiva antes de iniciar Phase 6 PLAN.

**H-03 — Cobertura UC->FR muy parcial.** Plan Maestro estima ~392 FR
para 49 UC. Solo 48 .rst existen (12% — todo en MOD_AUTH/USR/ACC).
MOD_PIP, RPT, ALR, AUD, LOG no tienen ningun .rst. El 88% restante esta
solo como referencias dispersas en el indice.

**H-04 — Pedagogico contamina indice (ratio 5:1).** De 315 IDs FR
detectados, ~51 son IACT reales (16%), ~264 son pedagogicos o ruido.
Migracion a v4.0.0 debe excluir explicitamente el dominio quimico —
sugerido marcar `pedagogic: true` o mover a path separado fuera de
`requisitos/`.

**H-05 — Recomendacion de nomenclatura.** Adoptar v4.0.0
`FR_MOD_UC_NN_Nombre` como UNICA forma valida. Los 48 .rst canonicos
deben renombrarse fisicamente en Phase 10 EXECUTE conforme al mapping
de H-02. Series `FR-MOD-NNN` (sin UC) deben descartarse o reescribirse
porque pierden trazabilidad al UC origen requerida por Larman (Plan
Maestro seccion 4.1).

**H-06 — BR vinculadas verificadas.** BR_005, BR_006, BR_007, BR_008,
BR_009, BR_012, BR_013 cubren AUTH+USR+ACC. BRs para RPT/ALR/PIP/AUD
(BR_011, BR_014, BR_015, BR_017..020) existen pero no estan vinculadas
en .rst FR — pendiente al generar el resto del catalogo.
