# Hallazgos en Provisioners — Post Fase 2

**Fecha:** 2026-05-07
**Contexto:** Analisis profundo de la Fase 2 revelo que los provisioners
tenian informacion desactualizada respecto al refactor de `ivr_es_dia_semana`.
**Resultado:** 3 errores encontrados, 3 corregidos en este commit.

---

## Hallazgo P-001 — COMMENT incorrecto en `llamadas_entre_semana`

**Archivo:** `provisioners/mariadb/schema_base_ivr.sql`
**Severidad:** MEDIA — el COMMENT erroneo estaba siendo almacenado en la BD
**Linea:** 57

### Antes

```sql
llamadas_entre_semana INT NOT NULL DEFAULT 0
    COMMENT 'COUNT de llamadas en días hábiles MX (lunes-viernes, no festivos)',
```

### Despues

```sql
llamadas_entre_semana INT NOT NULL DEFAULT 0
    COMMENT 'COUNT de llamadas en dias lunes-viernes. El IVR opera 7 dias — festivos incluidos.',
```

### Por que importa

El COMMENT de una columna se almacena en el schema de MariaDB y es visible
via `DESCRIBE`, `SHOW CREATE TABLE` e `information_schema.columns`. Un COMMENT
que dice "no festivos" contradice directamente la decision de diseno tomada:
el IVR opera 7 dias y `ivr_es_dia_semana` NO excluye festivos.

Estado en la BD antes de la correccion:

```sql
SELECT column_comment FROM information_schema.columns
WHERE table_schema='ivr_legacy'
  AND table_name='base_ivr_detalle'
  AND column_name='llamadas_entre_semana';
-- Resultado: '' (vacio)
```

El COMMENT estaba vacio porque el `ALTER TABLE CHANGE` que renombro la
columna de `llamadas_dias_habiles` a `llamadas_entre_semana` no especifico
el COMMENT, quedando en blanco. El provisioner tenia el texto incorrecto
pero no importaba porque `CREATE TABLE IF NOT EXISTS` no actualiza columnas
existentes.

---

## Hallazgo P-002 — `CREATE TABLE IF NOT EXISTS` no propaga cambios de columna

**Archivo:** `provisioners/mariadb/schema_base_ivr.sql`
**Severidad:** MEDIA — el provisioner no era idempotente para cambios de metadata

### El problema

```sql
CREATE TABLE IF NOT EXISTS base_ivr_detalle ( ... );
```

Si la tabla ya existe, MariaDB ignora completamente el `CREATE TABLE`.
Esto significa que:
- Un COMMENT incorrecto en el provisioner no se corrige al re-ejecutarlo
- Un cambio de tipo de columna en el provisioner no se aplica
- Un indice nuevo en el provisioner no se crea

El provisioner es idempotente para la **existencia** de la tabla, pero no
para los **cambios de metadata** en tablas existentes.

### La correccion

Se agrego un `ALTER TABLE` inmediatamente despues del `CREATE TABLE`:

```sql
CREATE TABLE IF NOT EXISTS base_ivr_detalle ( ... );

-- Garantizar que el COMMENT de llamadas_entre_semana este actualizado
-- aunque la tabla ya exista (CREATE TABLE IF NOT EXISTS no modifica columnas existentes)
ALTER TABLE base_ivr_detalle
    MODIFY COLUMN llamadas_entre_semana INT NOT NULL DEFAULT 0
    COMMENT 'COUNT de llamadas en dias lunes-viernes. El IVR opera 7 dias — festivos incluidos.';
```

Este `ALTER TABLE` es seguro porque:
1. Si la columna no existe: error detectado en deploy (falla explicitamente)
2. Si la columna existe con COMMENT diferente: lo actualiza sin perder datos
3. Si la columna existe con COMMENT correcto: operacion no-op (sin costo real)

### Verificacion post-correccion

```sql
SELECT column_name, column_comment
FROM information_schema.columns
WHERE table_schema='ivr_legacy'
  AND table_name='base_ivr_detalle'
  AND column_name = 'llamadas_entre_semana';
```

```
column_name            column_comment
llamadas_entre_semana  COUNT de llamadas en dias lunes-viernes. El IVR opera 7 dias — festivos incluidos.
```

---

## Hallazgo P-003 — Comentarios SQL obsoletos en `sp_rpt_reportes.sql`

**Archivo:** `provisioners/mariadb/sp_rpt_reportes.sql`
**Severidad:** BAJA — comentarios en el codigo fuente del SP, no en la BD

### Lineas corregidas

| Linea | Antes | Despues |
|---|---|---|
| 18 | `KPIs con SLA y días hábiles` | `KPIs con SLA y dias de semana (lunes-viernes)` |
| 299 | `clasificación SLA y días hábiles.` | `clasificacion SLA y dias de semana.` |
| 335 | `-- Días hábiles del periodo de actividad` | `-- Dias lunes-viernes del periodo de actividad` |
| 341 | `-- Días hábiles transcurridos desde la última actividad` | `-- Dias lunes-viernes transcurridos desde la ultima actividad` |
| 359 | `-- Basada en volumen total y días hábiles sin actividad reciente` | `-- Basada en volumen total y dias de semana sin actividad reciente` |

Estos son comentarios dentro del cuerpo del SP. No afectan la ejecucion
pero confunden a quien lee el codigo fuente.

---

## Hallazgo P-004 — Plan V2.1 T-036: cleanup con UPDATE en vez de DELETE

**Archivo:** `docs/architecture/PLAN-IMPLEMENTACION-V2.1.md`
**Severidad:** BAJA — afecta la limpieza de datos de test, no la funcionalidad

### El problema

El plan indica como cleanup de T-036:

```sql
UPDATE job_execution_log SET status='SUCCESS' WHERE id = @fake_id;
```

Esto deja el registro en la tabla con `ejecutado_por='test_t036'`.
El registro correcto de cleanup es:

```sql
DELETE FROM job_execution_log WHERE id = @fake_id;
```

### Estado actual de la BD

```sql
SELECT id, step_name, status, ejecutado_por, duracion_seg
FROM job_execution_log ORDER BY id;
```

```
id  step_name  status   ejecutado_por  duracion_seg
1   maestro    SUCCESS  test_t036      NULL
2   maestro    SKIP     evt_etl_diario 0
```

El registro `id=1` es ruido de test. `duracion_seg=NULL` porque fue
insertado directamente (sin `end_time`), lo que hace que la columna
generada no pueda calcular la duracion.

### Correccion del plan

Se actualiza la instruccion de cleanup en T-036 de:
```sql
UPDATE job_execution_log SET status='SUCCESS' WHERE id = @fake_id;
```
A:
```sql
DELETE FROM job_execution_log WHERE id = @fake_id;
```

### Limpieza en el sandbox

```sql
DELETE FROM job_execution_log WHERE ejecutado_por='test_t036';
```

---

## Estado de los provisioners post-correccion

| Archivo | Estado |
|---|---|
| `funciones_utilidad.sql` | Correcto — menciona festivos en el contexto apropiado (explicacion del refactor) |
| `schema_base_ivr.sql` | Corregido — COMMENT correcto + ALTER TABLE para propagacion en redespliegue |
| `sp_etl_pipeline.sql` | Correcto — sin referencias a festivos o dias habiles |
| `sp_rpt_reportes.sql` | Corregido — 5 comentarios internos actualizados |

---

## Leccion aprendida

Cuando se hace un refactor de nomenclatura que afecta a un concepto
de negocio (como cambiar "dias habiles" a "entre semana"), los lugares
a revisar son:

1. Nombres de funciones y columnas (renombrado funcional) ← hecho en commit 1e7587d
2. COMMENT de columnas en el schema DDL ← faltaba, corregido aqui
3. Comentarios inline en SPs ← faltaban en sp_rpt_reportes.sql, corregido aqui
4. Documentacion de arquitectura ← hecho en commits previos
5. ALTER TABLE para propagar cambios de metadata a BD existente ← faltaba, corregido aqui

El paso 2 y el paso 5 son los que mas facilmente se omiten porque
no causan errores funcionales — el codigo sigue funcionando, pero la
documentacion embebida en el schema queda desactualizada.
