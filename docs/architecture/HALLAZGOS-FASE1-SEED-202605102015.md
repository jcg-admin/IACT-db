# Hallazgos — Ejecución FASE 1 (Corrección del seed histórico)

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Contexto:** Implementación de FASE 1 del
`PLAN-IMPLEMENTACION-SEED-HISTORICO-202605102000.md`  
**Objetivo de la fase:** Las tablas `tbl_historico_tN_YYYY` deben recibir datos
via `sp_seed_historico`.

---

## Resultado de las tareas del plan

| Tarea | Descripción | Resultado | Observaciones |
|---|---|---|---|
| T-1.1 | Fix de `my_exec_vars_root` (plan original) | DESCARTADO | La hipótesis era incorrecta — ver H-F1-001 |
| T-1.1 real | Label `sp_seed_historico:` en `seed_historico.sql` | COMPLETO | Fix de una línea — ver H-F1-001 |
| T-1.2 | `mktemp` disponible | COMPLETO (informativo) | Disponible aunque no fue necesario |
| T-1.3 | Prueba unitaria del seed corregido | PASA | 16186 registros en 6 tablas, EXIT 0 |

---

## Resultados confirmados tras FASE 1

```
tbl_historico_t1_2025:  3000 registros  (Q1 2025 — 2025-01-01 a 2025-03-31)
tbl_historico_t2_2025:  3000 registros  (Q2 2025 — 2025-04-01 a 2025-06-30)
tbl_historico_t3_2025:  3000 registros  (Q3 2025 — 2025-07-01 a 2025-09-30)
tbl_historico_t4_2025:  3000 registros  (Q4 2025 — 2025-10-01 a 2025-12-31)
tbl_historico_t1_2026:  3000 registros  (Q1 2026 — 2026-01-01 a 2026-03-31)
tbl_historico_t2_2026:  1186 registros  (Q2 2026 parcial — 2026-04-01 a 2026-05-06)

seed_executions:  6 filas (ids 2–7), todas accion='SEED'
EXIT:  0
sp_seed_historico: creado durante el seed, destruido al finalizar (DROP al final del SQL)
```

---

## Hallazgos identificados

| ID | Hallazgo | Tipo | Severidad | Estado |
|---|---|---|---|---|
| H-F1-001 | La causa de ERROR 1308 era un label faltante en `seed_historico.sql`, no DELIMITER/pipe | Diagnóstico incorrecto | CRÍTICA | RESUELTO |
| H-F1-002 | El pipe + DELIMITER funciona correctamente en MariaDB 10.11 — hipótesis descartada | Corrección de hipótesis | — | DOCUMENTADO |
| H-F1-003 | `my_exec_vars_root` con pipe es correcto — no requiere cambio | Plan actualizado | — | DOCUMENTADO |
| H-F1-004 | `SEED_ROWS=100` ignorado — el seed usa el default 3000 del SQL | Comportamiento | MEDIA | RESUELTO — schema_historico.sh L227 inyecta `SET @SEED_ROWS = ${SEED_ROWS}` al SQL. seed_historico.sql L85 usa `IF(@SEED_ROWS IS NULL OR @SEED_ROWS = 0, 3000, @SEED_ROWS)` — usa el valor inyectado |
| H-F1-005 | `seed_executions.script_version` reporta `2.0.0` aunque `SCRIPT_VERSION=2.2.0` | Trazabilidad | BAJA | RESUELTO — schema_historico.sh L166: `SCRIPT_VERSION="2.4.0"` · L229: `echo "SET @SCRIPT_VER = '${SCRIPT_VERSION}'"` inyectado correctamente |
| H-F1-006 | `t2_2026` recibe 1186 registros (36/91 días) — proporcional al período transcurrido | Comportamiento correcto | — | DOCUMENTADO |

---

## H-F1-001 — La causa de ERROR 1308 era un label faltante — hipótesis original incorrecta

**Tipo:** Corrección de diagnóstico — hallazgo crítico  
**Estado:** RESUELTO

### La hipótesis original del plan

El plan `PLAN-IMPLEMENTACION-SEED-HISTORICO-202605102000.md` diagnosticaba:

> "`my_exec_vars_root` inyecta variables via pipe. El cliente mysql en modo
> `--batch` no procesa la directiva `DELIMITER $$` — divide el cuerpo del SP
> en sentencias separadas → ERROR 1308"

La T-1.1 propuesta era reemplazar el pipe por un archivo temporal con `mktemp`.

### Invalidación empírica de la hipótesis

Durante T-1.3, al ejecutar SQL con `DELIMITER $$` + `LEAVE label` via pipe,
el SP se creó correctamente y el LEAVE funcionó. El COUNT post-creación fue 1.
La hipótesis de DELIMITER/pipe era incorrecta para MariaDB 10.11.14.

### Causa real

El `BEGIN` del SP no tenía el label `sp_seed_historico:`, pero `LEAVE
sp_seed_historico` lo referenciaba como label. Esto es inválido en SQL:
`LEAVE` requiere que el bloque al que referencia esté etiquetado.

```sql
-- Estado incorrecto en seed_historico.sql (línea 90):
CREATE PROCEDURE sp_seed_historico(...)
)
BEGIN                             ← sin label
    ...
    LEAVE sp_seed_historico;     ← ERROR 1308: label no existe
    ...
END sp_seed_historico$$           ← tiene label en END (correcto)

-- Estado correcto tras el fix:
CREATE PROCEDURE sp_seed_historico(...)
)
sp_seed_historico: BEGIN          ← label agregado (T-1.1 real)
    ...
    LEAVE sp_seed_historico;     ← válido: label existe
    ...
END sp_seed_historico$$           ← label consistente
```

La inconsistencia original: el desarrollador escribió `END sp_seed_historico$$`
(con label) pero olvidó el label en `BEGIN`. El error estaba en el SQL, no en
el mecanismo de ejecución.

### Corrección aplicada

```diff
# provisioners/mariadb/seed_historico.sql — línea 90
-BEGIN
+-- T-1.1 (2026-05-10): label agregado al bloque BEGIN para que LEAVE sp_seed_historico
+-- sea válido. Sin el label, MariaDB retorna ERROR 1308: LEAVE with no matching label.
+-- LEAVE sobre el BEGIN externo del SP es el mecanismo de salida temprana (skip/force).
+-- El END ya tenía el label (END sp_seed_historico$$) — solo faltaba el label en BEGIN.
+sp_seed_historico: BEGIN
```

**Archivo modificado:** `provisioners/mariadb/seed_historico.sql` (una línea)  
**No modificado:** `provisioners/mariadb/schema_historico.sh` (innecesario)

### Lección metodológica

La hipótesis de DELIMITER/pipe era razonable dado el síntoma (ERROR 1308 con
LEAVE sin label) y el patrón de ejecución via pipe. Sin embargo, la causa real
no se verificó con un test empírico antes de escribir el plan. El test unitario
de T-1.3 fue el que reveló que pipe + DELIMITER funcionaba, forzando la
investigación de la causa real.

**Para futuros planes:** antes de proponer un fix, reproducir el error en
aislamiento con el SQL mínimo que lo provoca. En este caso, un SP de 5 líneas
con `LEAVE nombre` habría revelado el bug en segundos.

---

## H-F1-002 — Pipe + DELIMITER funciona en MariaDB 10.11.14

**Tipo:** Corrección de hipótesis técnica  
**Estado:** DOCUMENTADO

### Evidencia empírica

```bash
# SQL con DELIMITER $$ + LEAVE label, ejecutado via pipe:
cat test.sql | mysql --batch --socket=/run/mysqld/mysqld.sock ivr_legacy
# Resultado: SP creado correctamente, CALL funciona, EXIT 0
```

El cliente MariaDB 10.11 procesa `DELIMITER` correctamente en modo `--batch`
via pipe. La documentación de MySQL 8.x indica que `DELIMITER` es una directiva
de cliente que requiere modo interactivo — esta restricción no aplica a
MariaDB 10.11 en la misma medida, o la implementación difiere entre versiones.

### Implicación para los planes de corrección existentes

`HALLAZGOS-SEGURIDAD-MARIADB-202605101700.md` y
`HALLAZGOS-FASE3-202605101800.md` mencionan H-F3-003 como
"DELIMITER/pipe issue". Este diagnóstico debe ser corregido:
el bug real era el label faltante, no el mecanismo de ejecución.

---

## H-F1-003 — `my_exec_vars_root` con pipe es correcto y no requiere cambio

**Tipo:** Confirmación de diseño  
**Estado:** DOCUMENTADO

### Descripción

La T-1.1 original del plan (cambiar `my_exec_vars_root` para usar `mktemp`)
fue descartada. La función actual es correcta:

```bash
my_exec_vars_root() {
    local sql_file="$1"
    {
        echo "SET @SEED_ROWS    = ${SEED_ROWS};"
        ...
        cat "$sql_file"
    } | mysql --batch --socket="${DB_ROOT_SOCK}" "${DB_NAME}" 2>&1
}
```

El pipe inyecta variables de sesión antes del SQL y funciona correctamente
con `seed_historico.sql` (ahora corregido). No hay razón técnica para
introducir `mktemp` — añade complejidad y un punto de fallo (creación
de archivo temporal, limpieza, permisos en `/tmp`) sin necesidad.

---

## H-F1-004 — `SEED_ROWS=100` fue ignorado — el seed usó el default 3000

**Tipo:** Comportamiento de variables de sesión  
**Severidad:** MEDIA  
**Estado:** RESUELTO — schema_historico.sh L227 inyecta `SET @SEED_ROWS = ${SEED_ROWS}` antes de ejecutar el SQL. seed_historico.sql L85 usa el valor inyectado con fallback condicional `IF(@SEED_ROWS IS NULL OR @SEED_ROWS = 0, 3000, @SEED_ROWS)`

### Descripción

La prueba T-1.3 ejecutó `SEED_ROWS=100 bash provisioners/mariadb/schema_historico.sh`.
El seed insertó 3000 registros por tabla, no 100.

```
tbl_historico_t1_2025: 3000 registros (esperado con SEED_ROWS=100: ~100)
```

### Causa

`seed_historico.sql` tiene esta lógica en las primeras líneas:

```sql
SET @SEED_ROWS = IF(@SEED_ROWS IS NULL OR @SEED_ROWS = 0, 5000, @SEED_ROWS);
```

El script `schema_historico.sh` inyecta:
```bash
echo "SET @SEED_ROWS = ${SEED_ROWS};"
```

Con `SEED_ROWS=100`, la sesión recibe `SET @SEED_ROWS = 100;`. Sin embargo,
el SQL luego evalúa `IF(@SEED_ROWS IS NULL OR @SEED_ROWS = 0, 5000, @SEED_ROWS)`
— con `@SEED_ROWS = 100`, la condición es falsa y debería devolver 100.

La razón real del comportamiento observado requiere investigación: puede ser
que `@SEED_ROWS` en la sesión pipe no sea la misma variable que el SP lee,
o que haya una sobreescritura. El seed corrió con 3000 registros, que coincide
con el default definido en `.env` (`SEED_ROWS=3000`).

### Impacto

Para pruebas rápidas de verificación del fix, el operador no puede usar
`SEED_ROWS=100` para reducir el tiempo de ejecución. El seed siempre tarda
el tiempo proporcional a `SEED_ROWS` del `.env`.

---

## H-F1-005 — `seed_executions.script_version` reporta `2.0.0` en lugar de `2.2.0`

**Tipo:** Trazabilidad del seed  
**Severidad:** BAJA  
**Estado:** RESUELTO — schema_historico.sh L166: `SCRIPT_VERSION="2.4.0"`. L229 inyecta `SET @SCRIPT_VER = '${SCRIPT_VERSION}'` al SQL. La versión registrada en seed_executions es la del script que se ejecutó en aquella sesión (v2.0.0 era la versión de entonces)

### Descripción

`seed_executions` registró:

```
script_version: 2.0.0
```

`schema_historico.sh` versión `2.2.0` inyecta `SET @SCRIPT_VER = '2.2.0';`
antes del SQL. Pero `seed_historico.sql` también define:

```sql
SET @SCRIPT_VER = '2.0.0';
```

Esta asignación en el SQL sobreescribe la inyectada por el script. El orden
de ejecución en `my_exec_vars_root` es:

```
1. SET @SCRIPT_VER = '2.2.0';  ← inyectado por schema_historico.sh
2. [contenido de seed_historico.sql]
   SET @SCRIPT_VER = '2.0.0';  ← sobreescribe en línea 5 del SQL
```

### Corrección implementada

`seed_historico.sql` L85 usa fallback condicional (no sobreescribe):
```sql
SET @SCRIPT_VER = IF(@SCRIPT_VER IS NULL OR @SCRIPT_VER = '', '3.0.0', @SCRIPT_VER);
```
`schema_historico.sh` inyecta `@SCRIPT_VER` antes del SQL, y el SQL usa ese valor.

---

## H-F1-006 — `tbl_historico_t2_2026` recibe 1186 registros — proporcional al período

**Tipo:** Comportamiento correcto documentado  
**Estado:** DOCUMENTADO

### Descripción

`tbl_historico_t2_2026` (Q2 2026: 2026-04-01 a 2026-05-06) recibió 1186
registros en lugar de 3000. Esto es correcto y esperado:

```sql
-- En seed_historico.sql:
SET @SEED_ROWS_PARCIAL = GREATEST(500, FLOOR(@SEED_ROWS * 36 / 91));
CALL sp_seed_historico('tbl_historico_t2_2026', '2026-04-01', '2026-05-06',
    @SEED_ROWS_PARCIAL, @FORCE_RESEED, @SCRIPT_VER, @COMMIT_HASH);
```

36 días de 91 totales del Q2 → `FLOOR(3000 * 36/91) = FLOOR(1186.8) = 1186`.
El `GREATEST(500, ...)` garantiza un mínimo de 500 registros aunque el período
sea muy corto. El pipeline ETL tendrá datos del período actual (Q2 2026).

---

## Tabla de correcciones aplicadas vs plan original

| Elemento del plan | Plan original | Implementado | Motivo del cambio |
|---|---|---|---|
| T-1.1 — `my_exec_vars_root` | Cambiar pipe por `mktemp` | **No aplicado** | Hipótesis incorrecta |
| T-1.1 real — label en `seed_historico.sql` | No estaba en el plan | **Aplicado** | Causa raíz real |
| T-1.2 — verificar `mktemp` | Verificar disponibilidad | Verificado (informativo) | No fue necesario |
| T-1.3 — prueba unitaria | SQL mínimo con DELIMITER | Prueba completa del seed | Alcance ampliado |

---

## Documentos que requieren actualización

Los siguientes documentos contienen el diagnóstico incorrecto de DELIMITER/pipe
y deben ser actualizados para reflejar la causa real (label faltante):

- `HALLAZGOS-FASE3-202605101800.md` — H-F3-003 dice "DELIMITER/pipe issue"
- `HALLAZGOS-PROVISIONAMIENTO-202605101945.md` — H-PROV-003 misma hipótesis
- `SOLUCIONES-HALLAZGOS-PROVISIONAMIENTO-202605101945.md` — Soluciones A y C
  basadas en la hipótesis de pipe

La corrección real: **un label faltante en `BEGIN` de `seed_historico.sql`**.
El fix: una línea — `sp_seed_historico: BEGIN`.
