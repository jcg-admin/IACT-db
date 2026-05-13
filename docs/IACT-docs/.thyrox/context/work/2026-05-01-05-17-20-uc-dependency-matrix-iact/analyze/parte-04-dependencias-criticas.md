```yml
created_at: 2026-05-01 05:17:20
project: IACT-docs
work_package: 2026-05-01-05-17-20-uc-dependency-matrix-iact
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
language: es
parte: 4 de 6
```

# PARTE 4 — Dependencias críticas detalladas

> Ampliación de Parte 1 § 1.3-1.4: las cuatro
> rutas críticas paralelas en detalle paso a
> paso, y las tres dependencias transversales
> (T-01, T-02, T-03) con su mecanismo de
> implementación, su impacto en el grafo y los
> riesgos asociados.

## 4.1 Las cuatro rutas críticas paso a paso

### 4.1.1 Ruta A — Sistema (background)

Ruta de **disponibilidad de datos**. Sin esta
ruta, los reportes RPT no tienen qué mostrar y
las alertas ALR no se disparan.

| Paso | UC / proceso | Output verificable |
|------|--------------|--------------------|
| A.1 | (Externo) ETL job programado se dispara dentro de la ventana CNST-006 | Job iniciado en ETLExecution.state = RUNNING |
| A.2 | UC_PIP_01 — supervisar progreso, detectar fallos | Status visible para AGR-009 |
| A.3 | (Externo) ETL termina, escribe en BD analítica respetando CNST-008 | ETLExecution.state = COMPLETED, rows_loaded > 0 |
| A.4 | UC_PIP_03 — confirmar disponibilidad | Devuelve true → datos consumibles aguas abajo |

Tiempo total típico: 30-90 min nocturnos
(ventana CNST-006/008). Si sale de la ventana,
UC_PIP_01 dispara alerta.

Riesgo dominante: si el ETL falla más de N veces
consecutivas, el dashboard RPT muestra datos
stale. Mitigación: UC_PIP_04 reintento manual +
UC_ALR_01 con Threshold sobre antigüedad de
datos.

### 4.1.2 Ruta B — Operador / Supervisor

Ruta de **valor de negocio**. Lo que un
supervisor del call center hace en su día.

| Paso | UC | Pre-requisito |
|------|----|---------------|
| B.1 | UC_AUTH_01 — Iniciar Sesion | credenciales válidas |
| B.2 | UC_AUTH_04 — Cambiar Contrasena (sólo primer login per CNST-003) | flag first_login en User |
| B.3 | UC_PERM_07 — Verificar Permiso (transparente, transversal) | Session activa |
| B.4 | UC_RPT_01 — Ver Dashboard | función RPT-001 ``view_reports`` asignada al usuario |
| B.5 | (opcional) UC_RPT_02 — drill-down métricas tiempo real | función RPT-002 ``view_dashboard`` |
| B.6 | (opcional) UC_RPT_03..17 — históricos / scopes específicos | funciones del cluster RPT |
| B.7 | (opcional) UC_RPT_04 — exportar | función RPT-004/005/006 según formato |

Tiempo: B.1 + B.2 + B.3 + B.4 ≈ < 5 segundos en
condiciones normales (excluido cambio de
contraseña forzado).

Acceptance criterion del producto: los pasos
B.1 → B.4 deben funcionar para que un supervisor
diga "el sistema funciona".

### 4.1.3 Ruta C — Administrador RBAC

Ruta de **bootstrap del sistema**. Sin esta ruta
no se puede onboarding usuarios ni mantener
RBAC.

| Paso | UC | Output |
|------|----|--------|
| C.1 | UC_AUTH_01 (admin) | Session admin activa |
| C.2 | UC_PERM_07 (transversal) | función ACC-003 verificada |
| C.3 | UC_USR_02 — Consultar Usuarios | listado paginado de Users |
| C.4 | UC_ACC_03 — Consultar Permisos del usuario seleccionado | resolución completa de permisos efectivos |
| C.5 | (acción) UC_USR_01 / UC_ACC_01 / UC_ACC_04 — onboarding | nuevo User, Assignments creados |

Caso especial: el primer admin se crea por
seed/migration de BD; no hay paso C.5 para él.

### 4.1.4 Ruta D — Auditor

Ruta de **compliance**. Mandatoria por CNST-025.

| Paso | UC | Output |
|------|----|--------|
| D.1 | UC_AUTH_01 (auditor con AGR-006) | Session auditor activa |
| D.2 | UC_PERM_07 | función AUD-001 verificada |
| D.3 | UC_AUD_01 — Consultar Auditoria | AuditEvents listados según filtros |
| D.4 | (opcional) UC_AUD_02 — full-text search | resultados acotados |
| D.5 | (opcional) UC_AUD_03 / UC_AUD_04 — exportar / generar reporte compliance | artifact firmado |

CNST-025 garantiza que los AuditEvents son
inmutables; esto significa que UC_AUD_01..04 son
siempre lectura sin riesgo de modificación
accidental.

## 4.2 Diagrama unificado del flujo crítico

::

                    +------------+
                    | ETL job    |   (Ruta A — Sistema)
                    | externo    |
                    +-----+------+
                          |
                          v
                    +------------+
                    | UC_PIP_01  |
                    | Supervisar |
                    +-----+------+
                          |
                          v
                  +-----------------+
                  | Datos analítica |
                  | disponibles     |
                  +-----------------+
                          |
                          v
                    +------------+
                    | UC_AUTH_01 |   (entrada universal —
                    | Login      |    rutas B / C / D)
                    +-----+------+
                          |
            +-------------+-------------+
            |                           |
   primer login?                  no primer login
            |                           |
            v                           |
   +------------+                       |
   | UC_AUTH_04 |                       |
   | Cambiar PW |---------+             |
   +------------+         |             |
                          v             v
                    +------------+
                    | UC_PERM_07 |   (transversal —
                    | Verif Perm |    cada request)
                    +-----+------+
                          |
        +-----------------+--------------+
        |                 |              |
        v                 v              v
   +---------+     +-----------+    +---------+
   |Operador |     |Admin RBAC |    |Auditor  |
   +----+----+     +-----+-----+    +----+----+
        |                |               |
        v                v               v
   UC_RPT_01      UC_USR_02          UC_AUD_01
   Ver           Consultar           Consultar
   Dashboard     Usuarios            Auditoria
   (Ruta B)         |                   |
                    v                   |
                UC_ACC_03               |
                Consultar               |
                Permisos                |
                (Ruta C)             (Ruta D)

## 4.3 Dependencia transversal T-01 — Sesión activa

### Definición

**T-01**: cualquier UC operativo (no público)
requiere una ``Session.state = ACTIVE`` válida
para el usuario que lo invoca.

### UCs públicos (excepciones a T-01)

Sólo dos UCs son públicos en IACT — operan sin
sesión activa:

- **UC_AUTH_01**: por definición, su propósito
  es **crear** la Session.
- **UC_AUTH_03 (paso de validación de token de
  recuperación)**: el usuario que recuperó su
  contraseña accede vía token de un email, no
  vía Session. Sin embargo, el flujo desemboca
  en UC_AUTH_01 después.

Todos los demás UCs (59 de 61) requieren T-01.

### Mecanismo de implementación

- Middleware que intercepta cada HTTP request:
  1. Extrae el JWT del header ``Authorization``.
  2. Valida firma y expiración (CNST-002).
  3. Resuelve la ``Session`` correspondiente y
     verifica ``state = ACTIVE``.
  4. Si es inválida o expirada, retorna 401 sin
     invocar el UC.
  5. Si CNST-003 detecta que hay otra sesión
     más reciente para el mismo User, invalida
     la actual y retorna 401.

### Riesgo asociado

Si T-01 falla universalmente, todo el sistema
queda inaccesible salvo UC_AUTH_01 / UC_AUTH_03.
Es **single-point-of-failure** del producto. Se
mitiga con:

- Redundancia del servicio Auth (replica BD).
- Cache local de Sessions activas (invalidación
  TTL CNST-002).
- Health check de la dependencia en UC_LOG_06.

## 4.4 Dependencia transversal T-02 — Verificación de permiso

### Definición

**T-02**: cualquier UC operativo invoca
implícitamente UC_PERM_07 (verify permission)
con el par ``(user_id, function_id)`` antes de
ejecutar su flujo.

### Cobertura

- 100 % de UCs no públicos (los mismos 59 de
  T-01) invocan T-02.
- UC_AUTH_04 (cambiar contraseña propia) y
  UC_AUTH_02 (cerrar sesión propia) son
  particulares: no requieren función RBAC
  externa, sólo "el usuario sobre sí mismo".
  Estos UCs igualmente pasan por el middleware
  pero la función RBAC verificada es la
  identidad del owner contra el target.

### Orden de precedencia interno (UC_PERM_07)

Documentado en cabecera de
``uc-perm-07-verificar-permiso-usuario.rst`` per
Z.2.A:

1. **Revocaciones excepcionales**:
   ``ExceptionalPermission.state = REVOKED``
   con fecha vigente → DENEGADO.
2. **Concesiones excepcionales**:
   ``ExceptionalPermission.state = ACTIVE`` con
   fecha vigente (CNST-031) → AUTORIZADO.
3. **Asignaciones por grupo**: User ∈
   FunctionGroup que contiene la Function →
   AUTORIZADO.
4. **Asignaciones directas**: User ↔ Function
   directa → AUTORIZADO.
5. Sin match: DENEGADO.

Las revocaciones excepcionales **siempre ganan**
sobre las concesiones — esto permite revocar
selectivamente sin tocar el grupo.

### Mecanismo de implementación

- Decorador ``@require_function('FUNC-NNN')``
  sobre cada controller / endpoint.
- Cache LRU de permisos por par
  ``(user_id, function_id)`` con TTL corto
  (≈ 60 s) para reducir hits a BD.
- Invalidación de cache cuando se ejecuta
  UC_ACC_01, UC_ACC_02, UC_PERM_01, UC_PERM_02,
  UC_PERM_03, UC_PERM_04, UC_PERM_06 (cualquier
  cambio de Assignment / ExceptionalPermission /
  FunctionGroup).

### Riesgo asociado

Si T-02 falla, dos escenarios:

- **Fail-open** (deniega por defecto): el
  sistema queda inutilizable — peor que T-01.
- **Fail-closed** (autoriza por defecto):
  catastrófico — bypass total del RBAC.

La política IACT es **fail-closed estricto**
(implícito en CNST-030 SoD). Performance target:
< 50 ms (per cabecera del UC_PERM_07).

## 4.5 Dependencia transversal T-03 — Emisión de AuditEvent

### Definición

**T-03**: toda operación de **escritura** en
cualquier cluster emite uno o más ``AuditEvent``
inmutables (CNST-025).

### Cobertura

UCs que emiten T-03 (operación con efecto
persistente):

| Cluster | UCs que emiten AuditEvent |
|---------|----------------------------|
| AUTH | UC_AUTH_01, _02, _03, _04, _05 (todos) |
| USR | UC_USR_01, _03, _04 (excepto _02 lectura) |
| ACC | UC_ACC_01, _02, _04, _05, _08, _09 emite implícito al escribir |
| PERM | UC_PERM_01..06 (excepto _07, _08 lectura; _09, _10 lectura sobre AuditEvent) |
| RPT | UC_RPT_04, _07, _10, _11 (escrituras: ExportJob, ScheduledReport, SavedView, share log) |
| ALR | UC_ALR_01, _03, _05 (configurar threshold, acknowledge, suscripciones) |
| PIP | UC_PIP_04 (request retry) |
| AUD | UC_AUD_03 (meta-audit del export) |
| LOG | UC_LOG_04 (audit del export) |

UCs que sólo leen (no emiten T-03):

- AUTH: ninguno (todos tocan Session state)
- USR_02
- ACC_03
- PERM_07, _08, _09, _10
- RPT: _01, _02, _03, _08, _09, _12..17 (todas
  vistas)
- ALR_02, _04
- PIP_01, _02, _03
- AUD_01, _02, _04 (lecturas; _03 escribe meta)
- LOG_01, _02, _03, _05, _06, _07

### Mecanismo de implementación

- Middleware "audit emitter" que se conecta como
  observer a los métodos de servicio de escritura.
- Cada método de escritura de un UC declara su
  ``EventType`` (LOGIN, ACCESS_CHANGE,
  PERMISSION_GRANT, EXPORT_REQUESTED, etc.) en
  un decorador.
- El middleware crea el ``AuditEvent`` post-commit
  (no pre-commit) para garantizar que sólo eventos
  efectivamente persistidos generen audit.
- El insert al log usa transacción separada
  (CNST-025) — la falla del audit no aborta la
  operación principal pero sí queda alarmada.

### Riesgo asociado

Si T-03 falla silenciosamente, el sistema sigue
operando pero pierde compliance. Mitigación:

- Health check del servicio de audit en
  UC_LOG_06.
- Alerta automática (UC_ALR_03) si la rate de
  AuditEvent baja debajo del baseline esperado
  por más de N minutos.
- Reconciliación periódica entre logs de
  servicios de escritura y AuditEvent emitidos
  (UC_AUD_04 puede detectar gaps).

## 4.6 Resumen de dependencias críticas

::

   T-01 (Sesión activa)         → 59/61 UCs lo requieren
   T-02 (Verificar permiso)     → 59/61 UCs lo requieren
   T-03 (Emitir AuditEvent)     → 35/61 UCs lo emiten

   UCs públicos:                    UC_AUTH_01,
                                    UC_AUTH_03 (paso token)

   UCs sólo lectura sin audit:      26/61
   UCs escritura con audit:         35/61

   Camino crítico mínimo (Ruta B):  4 UCs
   = UC_AUTH_01 → UC_PERM_07 → UC_RPT_01
   ( + UC_PIP_01 prerequisito de datos en
     background )

----

Próxima parte: Parte 5 — matriz de criticidad y
duración (timeline, person-days, totales por
criticidad).
