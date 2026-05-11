# Hallazgos — Análisis de provision-mariadb.sh y grants de routines

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Contexto:** Análisis del estado de `provision-mariadb.sh` tras la
implementación de `GRANT EXECUTE` (v1.3.0) y revisión crítica para
instalación en N servidores.

---

## Resumen de hallazgos

| ID | Hallazgo | Severidad | Estado |
|---|---|---|---|
| H-GRANT-001 | `GRANT EXECUTE` acoplado al éxito de un archivo SQL específico | CRÍTICA | RESUELTO |
| H-GRANT-002 | `GRANT DML` acoplado al éxito de `schema_base_ivr.sql` | CRÍTICA | RESUELTO |
| H-GRANT-003 | `local exec_ok exec_fail` en cuerpo principal — `local` fuera de función | CRÍTICA | RESUELTO |
| H-GRANT-004 | `PASO4_ERRORS` — variable con número en el nombre | MEDIA | RESUELTO |
| H-GRANT-005 | `verify.sh` reporta 24/14 en lugar de 12/7 routines (cuenta @localhost + @%) | BAJA | RESUELTO |
| H-GRANT-006 | `provision-mariadb.sh` sin función `main()` — código ejecutable en cuerpo | ALTA | RESUELTO |
| H-GRANT-007 | La simulación anterior del job usó `root`, no `django_user` — resultados inválidos | Metodológico | DOCUMENTADO |
| H-GRANT-008 | `seed_historico_real.sql` referencia `FORCE_RESEED` obsoleto — pendiente archivar | MEDIA | RESUELTO — FASE 5: archivado en docs/referencias/scripts-sql/historico/ · commit 5a48040 |

---

## H-GRANT-001 — `GRANT EXECUTE` acoplado al éxito de un archivo SQL

**Severidad:** CRÍTICA  
**Estado:** RESUELTO en v1.4.0

### Descripción

En v1.3.0, el bloque de `GRANT EXECUTE` se ejecuta solo si el archivo
`sp_rpt_reportes.sql` se aplica exitosamente:

```bash
# PROBLEMA: el grant vive DENTRO del loop de deployment, atado a un archivo
for sql in funciones_utilidad.sql schema_base_ivr.sql sp_etl_pipeline.sql sp_rpt_reportes.sql; do
    if sql_exec_file "$SQL_PATH"; then
        if [[ "$sql" == "sp_rpt_reportes.sql" ]]; then
            # GRANT EXECUTE solo llega aquí si sp_rpt_reportes.sql tuvo éxito
        fi
    fi
done
```

**Escenarios de fallo en instalación en N servidores:**

1. `sp_rpt_reportes.sql` falla en servidor #3 → los 12 SPs de reporte se
   crean pero `django_user` no puede llamarlos → ERROR 1370 en producción.
2. Se agrega un nuevo SP en el futuro → hay que acordarse de re-ejecutar
   `provision-mariadb.sh` para que los grants nuevos se apliquen.
3. El archivo `sp_rpt_reportes.sql` se renombra o reordena → el `if` nunca
   dispara → todos los EXECUTE grants desaparecen.

### Corrección

Extraer los grants en funciones independientes `_apply_dml_grants()` y
`_apply_execute_grants()`, llamadas en un paso dedicado DESPUÉS del loop.
Las funciones consultan el estado actual de la BD en lugar de depender
del orden de ejecución de los archivos.

---

## H-GRANT-002 — `GRANT DML` acoplado al éxito de `schema_base_ivr.sql`

**Severidad:** CRÍTICA  
**Estado:** RESUELTO en v1.4.0

El mismo patrón de H-GRANT-001 aplica a los grants DML:

```bash
if [[ "$sql" == "schema_base_ivr.sql" ]]; then
    for tbl in base_ivr_detalle base_ivr_clientes ...; do
        GRANT SELECT, INSERT, UPDATE, DELETE ...  # solo si el archivo tuvo éxito
    done
fi
```

Si `schema_base_ivr.sql` falla en el servidor #2 (por ejemplo, si MariaDB
tiene una versión de schema anterior incompatible), las tablas pueden crearse
parcialmente pero `django_user` no tendría DML → el ETL falla silenciosamente
con `ERROR 1142 INSERT command denied`.

---

## H-GRANT-003 — `local` fuera de función

**Severidad:** CRÍTICA  
**Estado:** RESUELTO en v1.4.0

```bash
# En el cuerpo principal del script (fuera de cualquier función):
local exec_ok=0 exec_fail=0   # ← ERROR: local solo es válido en funciones
```

Confirmado con:
```bash
$ bash -c 'set -euo pipefail; local exec_ok=0'
bash: line 2: local: can only be used in a function
```

Con `set -euo pipefail` (que usa el script), este error mataría la ejecución
antes de otorgar ningún grant. La razón por la que no se detectó antes:
- `bash -n` no ejecuta código, solo verifica sintaxis estructural
- `local` es sintácticamente válido en cualquier contexto desde el parser
- El error solo emerge en tiempo de ejecución

El mismo problema existía con `local grant=` en v1.2.0 (H-EXEC-003), que fue
corregido para `GRANT_STMT` pero no se propagó al nuevo bloque de EXECUTE.

---

## H-GRANT-004 — `PASO4_ERRORS` — variable con número

**Severidad:** MEDIA  
**Estado:** RESUELTO en v1.4.0

El proyecto prohíbe explícitamente nombres con números tipo `01`, `02`, etc.
en scripts y variables. `PASO4_ERRORS` viola esta convención:

```bash
PASO4_ERRORS=0
for sql in ...; do
    ...
    (( ++PASO4_ERRORS )) || true
done
[[ $PASO4_ERRORS -eq 0 ]] && ...
```

**Corrección:** Renombrar a `SQL_DEPLOY_ERRORS` — describe el contenido
sin acoplar a un número de paso.

---

## H-GRANT-005 — `verify.sh` reporta 24/14 en lugar de 12/7

**Severidad:** BAJA  
**Estado:** RESUELTO en v1.4.0

```
GRANT EXECUTE OK — django_user puede invocar SPs (24 PROCEDURE, 14 FUNCTION)
```

`mysql.procs_priv` tiene una fila por combinación `(Host, User, Routine)`.
Con grants para `@localhost` y `@%`, cada routine tiene dos filas:
- 12 SPs × 2 hosts = 24 filas
- 7 funciones × 2 hosts = 14 filas

El mensaje es técnicamente correcto pero semánticamente confuso: el operador
ve "24 PROCEDURE" y no entiende por qué hay más registros que SPs.

**Corrección:** Usar `COUNT(DISTINCT Routine_name)` → muestra 12 y 7.

---

## H-GRANT-006 — Sin función `main()` en `provision-mariadb.sh`

**Severidad:** ALTA  
**Estado:** RESUELTO en v1.4.0

`provision-mariadb.sh` tiene funciones auxiliares al inicio pero el código
de ejecución principal está en el cuerpo del script, sin envoltura `main()`.
Esto tiene tres consecuencias:

1. `local` es inválido en el cuerpo principal (H-GRANT-003).
2. No hay punto de entrada claro — dificulta el testing y la lectura.
3. `schema_historico.sh` sí usa `main()` — inconsistencia entre scripts del
   mismo proyecto que aumenta la carga cognitiva para nuevos colaboradores.

**Corrección:** Envolver todo el código de ejecución en `main()` y llamarla
al final. Patrón ya establecido en `schema_historico.sh`:
```bash
main() {
    log_step 1 N "..."
    ...
}
main
```

---

## H-GRANT-007 — Simulación del job con `root`, no `django_user`

**Severidad:** Metodológico  
**Estado:** DOCUMENTADO

La simulación en `HALLAZGOS-JOB-ETL-SIMULACION-202605102245.md` describió
el comportamiento del job como si fuera producción real. Sin embargo:

- Los scripts Python de simulación usaron `connections['mysql']` y comandos
  `mysql --socket ... root` — conexión root.
- `django_user` no tenía `GRANT EXECUTE` en ese momento.
- En producción real, todo `callproc()` desde Django habría fallado con
  ERROR 1370 antes de llegar a cualquier lógica del SP.

Los escenarios A (evt_etl_diario) y B (manage.py run_etl) del documento
son arquitecturalmente correctos pero los resultados de "X filas procesadas"
corresponden a ejecuciones root, no a Django. El comportamiento funcional
es el mismo una vez aplicado el `GRANT EXECUTE` (H-GRANT-001).

---

## H-GRANT-008 — `seed_historico_real.sql` obsoleto

**Severidad:** MEDIA  
**Estado:** RESUELTO — FASE 5: archivado en docs/referencias/scripts-sql/historico/ · commit 5a48040

`provisioners/mariadb/seed_historico_real.sql` referencia `FORCE_RESEED`
y `sp_seed_historico_real` — conceptos eliminados en `seed_historico.sql`
v3.0.0. El archivo no está referenciado en ningún script de provisioning.

Decisión pendiente: archivar en `docs/referencias/`, eliminar, o actualizar.

---

## Principio arquitectónico: grants independientes del despliegue

En una instalación en N servidores, el estado de cada servidor puede variar:

```
Servidor 1 (fresco):    provision-mariadb.sh → OK completo
Servidor 2 (parcial):   sp_rpt_reportes.sql falló → SPs sin EXECUTE
Servidor 3 (re-run):    schemas ya existen → sql_exec_file falla en CREATE
```

Los grants deben ser idempotentes y ejecutables en cualquier estado:
- `GRANT` en MariaDB es idempotente — re-aplicar un grant existente no falla
- `GRANT EXECUTE ON PROCEDURE` falla si la routine no existe (ERROR 1305)
- La función `_apply_execute_grants()` debe filtrar solo routines existentes:

```bash
_apply_execute_grants() {
    # Consultar routines actuales → otorgar EXECUTE solo en las que existen
    while IFS= read -r name type; do
        GRANT EXECUTE ON ${type} `db`.`${name}` TO user@host;
    done < <(SELECT ROUTINE_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES ...)
}
```

Llamada después del loop de SQL y también en un PASO dedicado que se
puede re-ejecutar de forma segura en cualquier momento.
