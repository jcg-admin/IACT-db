> **Estado:** EJECUTADO — 2026-05-13, commit `6e92ca4`
> La decisión adoptó `pipeline_event_log`. Se renombraron la tabla, el schema y la vista.
> Este documento es el registro del análisis que justificó la decisión.

# Análisis — Nomenclatura de `ivr_error_log`

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Pregunta:** ¿Es adecuado el nombre `ivr_error_log`?  
**Método:** revisión de nomenclatura en sistemas reales de IVR/contact center,
ETL empresarial y plataformas de datos modernas.

---

## Qué usan los sistemas reales

### Genesys Info Mart — la plataforma de referencia del dominio IVR

La tabla `CTL_AUDIT_LOG` almacena cada transacción lógica que Genesys Info Mart
confirma, identificando el job ETL involucrado, el rango de fechas procesadas y
el estado de procesamiento.

La tabla `CTL_ETL_HISTORY` registra el estado del procesamiento ETL. Se agrega
una fila después de cada job completado. El ciclo ETL se divide en pequeñas
tareas y la tabla es un indicador útil del estado del procesamiento.

Genesys — el sistema de IVR/contact center más parecido al dominio de IACT-db —
usa el prefijo `CTL_` para todas las tablas de control administrativo y
distingue entre `AUDIT_LOG` (linaje de datos) e `HISTORY` (historial de ejecución).
Las tablas de datos de negocio tienen nombres sin `CTL_`.

### Databricks / Delta Pipelines — plataforma de datos moderna

El pipeline event log contiene toda la información relativa a un pipeline,
incluyendo audit logs, data quality checks, progreso del pipeline y data lineage.
Por defecto el nombre del hidden event log sigue el formato `event_log_{pipeline_id}`.

Databricks llama `pipeline_event_log` a la tabla que captura auditoría, calidad
de datos y progreso — exactamente lo que `ivr_error_log` hace en IACT-db.

### Telecom ETL — nomenclatura por origen

Si un registro es rechazado desde la fuente, se almacena en `error_source_output`.
Si no cumple las restricciones de la destino, se registra en `error_destination_output`.

El patrón telecom ETL diferencia el error por su origen: fuente vs destino. No
usa un prefijo de dominio (no llama a las tablas `telecom_error_*`).

### ETL Audit-Balance-Control — framework empresarial

El framework ABC recomienda mantener un log detallado de métricas operacionales
como tiempos de procesamiento y conteos de filas para proporcionar visibilidad
profunda del rendimiento del pipeline y tendencias históricas.

---

## El problema de fondo con `ivr_error_log`

### Problema 1 — el prefijo `ivr_` apunta al origen de datos, no al sistema que falla

Las tablas de IACT-db se dividen en dos familias semánticas:

```
base_ivr_detalle      ← datos del IVR procesados y agregados (dominio de negocio)
base_ivr_clientes     ← datos del IVR procesados y agregados (dominio de negocio)

job_execution_log     ← control del pipeline analítico (sin prefijo ivr_)
job_config            ← control del pipeline analítico (sin prefijo ivr_)
etl_runs              ← control del pipeline analítico (sin prefijo ivr_)
```

`ivr_error_log` rompe esta distinción. El prefijo `ivr_` en `base_ivr_*` indica
que la tabla **contiene datos provenientes del IVR**. El error log no contiene
datos del IVR — contiene errores de la plataforma analítica IACT que procesa
esos datos. El IVR es la fuente; IACT es el sistema que falla.

Un desarrollador nuevo al ver `ivr_error_log` asumiría que registra errores de
la central telefónica (el IVR). No es así — registra excepciones y fallos de
validación en los SPs de ETL y de reporte de IACT.

### Problema 2 — `error` es menos preciso que el contenido real

El ENUM `error_type` incluye:
- `PARAM_INVALIDO` — parámetro fuera del dominio válido (no es un "error del sistema")
- `VALIDACION` — sp_etl_validar detectó datos inconsistentes (es un resultado de negocio, no una excepción técnica)
- `ETL_FALLO` — excepción durante la carga (esto sí es un error)

"Error" es correcto para `ETL_FALLO` pero inexacto para `PARAM_INVALIDO` y
`VALIDACION`. En los sistemas reales, los nombres de tablas como `event_log`
(Databricks), `CTL_AUDIT_LOG` (Genesys) o `Data_Audit_Log` (IBM) son más
inclusivos porque cubren tanto excepciones técnicas como eventos operacionales.

---

## Candidatos de renombre

| Candidato | Patrón de referencia | Consistencia en IACT-db | Semántica |
|---|---|---|---|
| `pipeline_event_log` | Databricks `pipeline_event_log` | Nuevo en el proyecto | Captura todo: excepciones + validaciones + eventos |
| `pipeline_error_log` | ETL best practices | Nuevo en el proyecto | Solo errores — excluye eventos informativos |
| `etl_exception_log` | `etl_runs` existente en IACT-db | Consistente con `etl_*` | Preciso para ETL, pero no para SPs de reporte |
| `job_exception_log` | `job_execution_log` existente | Consistente con `job_*` | `job_execution_log = 'qué ejecutó'`, `job_exception_log = 'qué falló'` |
| `ctl_audit_log` | Genesys `CTL_AUDIT_LOG` | Nueva convención (`CTL_`) | Profesional, pero introduce un prefijo ajeno al estilo del proyecto |

---

## Evaluación por candidato

### `pipeline_event_log`

A favor:
- Inspiración directa en Databricks, que tiene el mismo caso de uso (auditoría + calidad + pipeline).
- `event_log` es más inclusivo que `error_log` — cubre excepciones técnicas, fallos de validación de negocio y parámetros inválidos de API sin forzar semántica.
- Elimina el prefijo `ivr_` incorrecto.

En contra:
- `event` podría confundirse con "eventos de llamada" en el contexto de un sistema IVR.
- Introduce el prefijo `pipeline_*` que no existe en otras tablas del proyecto.

### `pipeline_error_log`

A favor:
- Más claro que `event_log` en expresar que solo se registran errores.
- Elimina `ivr_`.

En contra:
- `pipeline` es ambiguo: ¿el pipeline del IVR fuente o el pipeline analítico de IACT?
- `error` sigue siendo menos preciso que `exception` para el contenido real.

### `etl_exception_log`

A favor:
- `etl_*` ya existe en el proyecto (`etl_runs`) — perfectamente consistente.
- `exception` es más preciso que `error` para lo que realmente se registra (excepciones de SPs).

En contra:
- `etl_` implica solo el proceso ETL. Los SPs de reporte (`sp_rpt_*`) no son ETL — son consultas de lectura. Nombrar la tabla `etl_exception_log` excluiría semánticamente esa categoría de errores.

### `job_exception_log`

A favor:
- `job_*` es el patrón dominante (`job_execution_log`, `job_config`).
- El par conceptual es limpio: `job_execution_log` = qué ejecutó el pipeline, `job_exception_log` = qué falló durante la ejecución.
- Seguiría la misma lógica que Genesys: `CTL_ETL_HISTORY` para ejecución, `CTL_AUDIT_LOG` para auditoría.

En contra:
- `job_` implica que solo aplica a los jobs ETL (`sp_etl_maestro`, `sp_etl_historico`). Los fallos de validación de parámetros en los SPs de reporte (`sp_rpt_*`) no son "jobs" — son peticiones de API.

---

## Recomendación

**`pipeline_event_log`** es el nombre más preciso si se quiere expresar todo el
alcance de la tabla (ETL + reporte + validación). Se alinea con la terminología
moderna de plataformas de datos.

**`job_exception_log`** es el nombre más consistente con el estilo interno del
proyecto si se acepta que "job" se interpreta como cualquier operación del pipeline
analítico, no solo los jobs ETL nocturnos. El par `job_execution_log` /
`job_exception_log` es intuitivo para cualquier desarrollador que conozca el schema.

**`etl_exception_log`** es una opción intermedia — consistente con `etl_runs`,
precisa sobre el tipo de contenido, pero semánticamente estrecha.

La decisión depende de una pregunta de diseño: ¿la tabla es el log de excepciones
del **pipeline ETL** (opción `job_*` / `etl_*`) o el log de eventos de toda la
**plataforma analítica** IACT incluyendo la capa de API de reportes (opción
`pipeline_*`)?

Si la tabla es exclusivamente para el pipeline ETL, `job_exception_log` es correcto.
Si la tabla captura también los errores de la API de reportes (como es el caso
actual — los 7 SPs de reporte registran `PARAM_INVALIDO`), entonces
`pipeline_event_log` refleja mejor el alcance real.

---

## Impacto del renombre en el proyecto

El renombre fue ejecutado en commit `6e92ca4` (2026-05-13) antes de T1.1.
Los cambios resultaron localizados y aplicables
(que es precisamente la tarea donde se registra la tabla en provision):

| Artefacto | Cambio |
|---|---|
| `provisioners/mariadb/schema_error_log.sql` | Renombrar archivo + `CREATE TABLE` |
| `provisioners/mariadb/objetos/vistas/v_errores_recientes` (dentro de schema_error_log.sql) | Actualizar referencia en `FROM ivr_error_log` |
| `scripts/provision-mariadb.sh` | Nombre del archivo schema |
| `verify.sh` | Nombre de la tabla en el check |
| Todos los documentos de análisis | Referencias textuales |
| `ANALISIS-DISENO-IVR-ERROR-LOG.md` | Renombrar y actualizar |

Los SPs de T1.2 y T1.3 aún no modificados (no tienen el INSERT al log).
El renombre es viable **antes** de implementar FASE 1.
