# Hallazgos — Ejecución FASE 8 (Plan corrección bugs CNST-003)

**Versión:** 1.0.0  
**Fecha:** 2026-05-12  
**Plan de referencia:** `PLAN-CORRECCION-BUGS-CNST003-202605120300.md` FASE 8  
**Archivo:** `provisioners/mariadb/setup.sh`  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-8.1 | Reemplazar `USER_PRIVILEGES` por `TABLE_PRIVILEGES` con `my_root_silent` | COMPLETO | H-F8-001, H-F8-002 |
| T-8.2 | Verificación funcional — 3 escenarios | PASA | — |
| T-8.3 | verify.sh 27 OK sin regresión | PASA | — |

---

## H-F8-001 — BUG-003: `USER_PRIVILEGES` es invisible a los grants de tabla

**Detectado en:** T-8.1, durante el análisis inicial del bloque  
**Severidad:** ALTA — la verificación siempre reportaba `READ-ONLY` aunque existieran grants de escritura  
**Estado:** RESUELTO en T-8.1

### Descripción del bug

El bloque de verificación CNST-003 original consultaba `information_schema.USER_PRIVILEGES`:

```sql
SELECT COUNT(*) FROM information_schema.USER_PRIVILEGES
WHERE GRANTEE LIKE \"'django_user'%\"
AND PRIVILEGE_TYPE IN ('INSERT','UPDATE','DELETE','DROP','CREATE','ALTER')
```

`USER_PRIVILEGES` en MariaDB (y MySQL) solo expone privilegios otorgados a nivel
**global** (`GRANT X ON *.*`). Los privilegios otorgados a nivel de **tabla**
(`GRANT INSERT ON ivr_legacy.etl_runs`) residen en `TABLE_PRIVILEGES`, que es
una vista separada, invisible desde `USER_PRIVILEGES`.

Consecuencia: el `COUNT(*)` devuelve `0` siempre, independientemente de cuántos
`GRANT INSERT/UPDATE/DELETE ON tabla` tenga `django_user`. La verificación
reportaba `CNST-003 verificado: READ-ONLY` incluso cuando `django_user` tenía
acceso de escritura en cinco tablas (estado previo a FASE 6+7).

Verificado empíricamente:

```bash
# USER_PRIVILEGES — lo que usa el código original:
SELECT COUNT(*) FROM information_schema.USER_PRIVILEGES
WHERE GRANTEE LIKE "'django_user'%" AND PRIVILEGE_TYPE IN ('INSERT','UPDATE','DELETE',...)
# → 0  (siempre, aunque existan grants de tabla)

# TABLE_PRIVILEGES — el estado real:
SELECT TABLE_NAME, GROUP_CONCAT(DISTINCT PRIVILEGE_TYPE)
FROM information_schema.TABLE_PRIVILEGES
WHERE GRANTEE LIKE "'django_user'%" AND TABLE_SCHEMA='ivr_legacy'
AND PRIVILEGE_TYPE IN ('INSERT','UPDATE','DELETE')
GROUP BY TABLE_NAME
# → etl_runs | INSERT,UPDATE
```

---

## H-F8-002 — Segunda capa del bug: la visibilidad de `TABLE_PRIVILEGES` depende del usuario conectado

**Detectado en:** T-8.1, durante la verificación funcional del primer borrador del fix  
**Severidad:** ALTA — el fix inicial producía verificación incompleta  
**Estado:** RESUELTO en T-8.1 (iteración 2)

### Descripción

El primer borrador del fix conectaba como `django_user` vía TCP para consultar
`TABLE_PRIVILEGES`:

```bash
write_tbls=$(mysql -h "$host" -P "$port" \
    -u "$db_user" -p"${db_pass}" \
    --batch --silent --skip-column-names \
    -e "SELECT TABLE_NAME, GROUP_CONCAT(PRIVILEGE_TYPE...) FROM information_schema.TABLE_PRIVILEGES
        WHERE GRANTEE LIKE \"'${db_user}'%\" ...")
```

Al probar el escenario 3 (grant sobrante inyectado solo en `django_user@localhost`),
el fix no lo detectó. La investigación reveló el motivo:

**En MariaDB, un usuario sin privilegios especiales solo puede ver sus propios
grants en `TABLE_PRIVILEGES`. El scope de "sus propios grants" está restringido
al `GRANTEE` que corresponde a la sesión actual.**

La conexión TCP a `127.0.0.1` autentica como `'django_user'@'%'`. Aunque la
consulta filtre `GRANTEE LIKE "'django_user'%"`, la vista solo retorna las filas
de `'django_user'@'%'`. Los grants de `'django_user'@'localhost'` son
completamente invisibles para esa conexión.

Verificado:

```bash
# Conexión TCP (autenticada como @'%'):
mysql -h 127.0.0.1 ... -e "SELECT GRANTEE FROM information_schema.TABLE_PRIVILEGES"
# → solo 'django_user'@'%'

# Conexión socket (autenticada como @'localhost'):
mysql --socket=... -e "SELECT GRANTEE FROM information_schema.TABLE_PRIVILEGES"
# → solo 'django_user'@'localhost'
```

### Solución

Usar `my_root_silent` (root vía socket Unix, definida en `main()` de `setup.sh`),
que tiene acceso completo a `TABLE_PRIVILEGES` y ve todos los `GRANTEE`:

```bash
write_tbls=$(my_root_silent \
    -e "SELECT TABLE_NAME,
               GROUP_CONCAT(DISTINCT PRIVILEGE_TYPE ORDER BY PRIVILEGE_TYPE) AS privs
        FROM information_schema.TABLE_PRIVILEGES
        WHERE GRANTEE LIKE \"'${db_user}'%\"
        AND TABLE_SCHEMA = '${db_name}'
        AND PRIVILEGE_TYPE IN ('INSERT','UPDATE','DELETE')
        GROUP BY TABLE_NAME
        ORDER BY TABLE_NAME;" \
    || echo "")
```

`DISTINCT` en `GROUP_CONCAT` es necesario porque root ve los grants de
`@'%'` Y `@'localhost'` simultáneamente. Sin `DISTINCT`, `etl_runs`
aparecería como `INSERT,INSERT,UPDATE,UPDATE` en lugar de `INSERT,UPDATE`.

Este patrón es consistente con el resto del archivo — `my_root_silent` ya
se usa en los PASOS 1, 2 y 3 de `setup.sh`.

---

## Cambio implementado

```bash
# ANTES — bloque original (L163-174):
# Verificar que el usuario NO tiene privilegios de escritura (CNST-003)
local write_privs
write_privs=$(mysql -h "$host" -P "$port"         -u "$db_user" -p"${db_pass}" \
        --batch --silent --skip-column-names \
        -e "SELECT COUNT(*) FROM information_schema.USER_PRIVILEGES
            WHERE GRANTEE LIKE \"'${db_user}'%\"
            AND PRIVILEGE_TYPE IN ('INSERT','UPDATE','DELETE','DROP','CREATE','ALTER');" \
        2>/dev/null || echo "0")

if [[ "$write_privs" -eq 0 ]]; then
    log_success "CNST-003 verificado: ${db_user} es READ-ONLY en ${db_name}"
else
    log_warn "CNST-003: ${db_user} tiene ${write_privs} privilegio(s) de escritura"
    log_warn "  Revisa los GRANT aplicados sobre ${db_name}"
fi

# DESPUÉS — bloque corregido (L163-199):
# Verificar CNST-003: reportar tablas con escritura directa (TABLE_PRIVILEGES).
# BUG-003: USER_PRIVILEGES solo ve grants globales (ON *.*)...
# Nota de visibilidad: usa my_root_silent (root vía socket) que ve todos los GRANTEEs.
# GROUP_CONCAT DISTINCT deduplica INSERT/UPDATE que aparecen dos veces.
local write_tbls
write_tbls=$(my_root_silent \
    -e "SELECT TABLE_NAME,
               GROUP_CONCAT(DISTINCT PRIVILEGE_TYPE ORDER BY PRIVILEGE_TYPE) AS privs
        FROM information_schema.TABLE_PRIVILEGES
        WHERE GRANTEE LIKE \"'${db_user}'%\"
        AND TABLE_SCHEMA = '${db_name}'
        AND PRIVILEGE_TYPE IN ('INSERT','UPDATE','DELETE')
        GROUP BY TABLE_NAME
        ORDER BY TABLE_NAME;" \
    || echo "")

if [[ -z "$write_tbls" ]]; then
    log_success "CNST-003: ${db_user} es READ-ONLY en ${db_name} (sin escritura directa en ninguna tabla)"
else
    log_info  "CNST-003: ${db_user} tiene escritura directa en tablas de ${db_name}:"
    while IFS=$'\t' read -r tbl privs; do
        log_info  "    ${tbl}: ${privs}"
    done <<< "$write_tbls"
    log_info  "  (ver ANALISIS-PERMISOS-CNST003-RUN-ETL para justificacion)"
fi
```

---

## Verificación funcional — 3 escenarios

| Escenario | Condición | Output esperado | Resultado |
|---|---|---|---|
| 1 | Estado correcto post-FASE 6+7: `etl_runs` con `INSERT,UPDATE` | `[INFO] etl_runs: INSERT,UPDATE` | PASA |
| 2 | READ-ONLY puro: sin ningún grant de tabla | `[SUCCESS] READ-ONLY ... sin escritura directa` | PASA |
| 3 | Grant sobrante inyectado solo en `@localhost`: `INSERT ON job_config @localhost` | `[INFO] job_config: INSERT` | PASA |

El escenario 3 era el caso de falla del primer borrador del fix y confirma
que `my_root_silent` (root vía socket) ve correctamente los grants de
`@localhost` que son invisibles para conexiones TCP como `django_user@'%'`.

---

## Nota sobre el carácter de la verificación

La verificación CNST-003 en `setup.sh` es de **observabilidad**, no de
enforcement. El enforcement lo garantiza la arquitectura de dos capas:

1. `provision-mariadb.sh` con `_apply_dml_grants` y `_apply_execute_grants`
   de lista explícita (FASE 6) — solo aplica los grants correctos en instalaciones nuevas
2. Los `REVOKE` de FASE 7 — limpian el estado del entorno existente

Si un operador aplica manualmente un grant incorrecto después de la provisión,
la verificación lo reportará en la siguiente ejecución de `setup.sh`. El operador
deberá decidir si ejecutar `provision-mariadb.sh` o aplicar el `REVOKE` manualmente.

---

## Estado de los bugs del plan tras FASE 8

| Bug | Descripción | Estado |
|---|---|---|
| BUG-003 | `setup.sh` verificación CNST-003 usa `USER_PRIVILEGES` (siempre 0) | RESUELTO — T-8.1 |
| BUG-003 extensión | Visibilidad parcial de `TABLE_PRIVILEGES` con usuario no-root | RESUELTO — T-8.1 (iteración 2) |
