# Hallazgos — Ejecución FASE 10 (Plan corrección bugs CNST-003)

**Versión:** 1.0.0  
**Fecha:** 2026-05-12  
**Plan de referencia:** `PLAN-CORRECCION-BUGS-CNST003-202605120300.md` FASE 10  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-10.1 | Auditoría técnica completa de todos los archivos modificados | PASA | H-F10-001 |
| T-10.2 | verify.sh final: 27 OK, 0 WARN, 0 ERR, EXIT 0 | PASA | — |
| T-10.3 | Commit de cierre | COMPLETO | — |

---

## H-F10-001 — Los SC1090 de shellcheck en 3 archivos son preexistentes, no introducidos en esta sesión

**Detectado en:** T-10.1, durante la auditoría final de shellcheck sobre todos los archivos modificados  
**Severidad:** INFORMATIVO — no son deuda técnica nueva  
**Estado:** DOCUMENTADO

### Descripción

La auditoría sistemática de los 6 shell scripts modificados en FASES 1-9 produjo
warnings de shellcheck en tres archivos:

- `provisioners/mariadb/backup_ivr_legacy.sh` — SC1090 en L50
- `provisioners/mariadb/setup.sh` — SC1090 en L34
- `scripts/provision-mariadb.sh` — SC1090 en L78

Los tres casos corresponden al mismo patrón:

```bash
if [[ -f "$ENV_FILE" ]]; then set -a; source "$ENV_FILE"; set +a; fi
```

SC1090 ("ShellCheck can't follow non-constant source") es un warning estructural
de shellcheck cuando el argumento de `source` es una variable, no un literal.
shellcheck no puede analizar el contenido del archivo en tiempo de análisis
estático y lo advierte.

**Verificación de preexistencia:** El commit `84ec799` (inmediatamente anterior
al inicio de las correcciones) ya producía el mismo SC1090 en `backup_ivr_legacy.sh`
al ejecutar `shellcheck`. Los commits de FASE 2, FASE 6 y FASE 8 que modificaron
estos archivos no agregaron ningún `source "$ENV_FILE"` nuevo — el patrón ya
existía antes de la sesión de corrección.

**Por qué no se corrige:** El patrón `source "$ENV_FILE"` con guarda `[[ -f ... ]]`
es correcto y es el estándar en todo el proyecto. La supresión con
`# shellcheck source=/path/to/.env` no aplica porque `.env` no está versionado
y su ruta varía por entorno. SC1090 en este contexto es un falso positivo
aceptado explícitamente en los filtros de verificación del proyecto
(`grep -v SC1090`).

---

## Auditoría técnica completa — FASES 1-9

### Shell scripts

| Archivo | Fase | bash -n | shellcheck (sin SC1090/SC1091) |
|---|---|---|---|
| `utils/core.sh` | FASE 1 | OK | Limpio |
| `utils/provisioning.sh` | FASE 1 | OK | Limpio |
| `provisioners/mariadb/backup_ivr_legacy.sh` | FASE 2 | OK | Limpio |
| `provisioners/adminer/ssl.sh` | FASE 3 | OK | Limpio |
| `scripts/provision-mariadb.sh` | FASE 6 | OK | Limpio |
| `provisioners/mariadb/setup.sh` | FASE 8 | OK | Limpio |

### SQL

| Archivo | Fase | Cambio | Verificación |
|---|---|---|---|
| `sp_etl_pipeline.sql` | FASE 4 | `UPDATE v_maestro_id` en handler PASO 5 | `grep "Falló etl_base_clientes"`: 1 ocurrencia |
| `sp_rpt_reportes.sql` | FASE 5 | 9 divisiones protegidas con NULLIF | Sin `/ (SELECT SUM` sin NULLIF |

### Python

| Archivo | Fase | pyflakes | py_compile |
|---|---|---|---|
| `poblar_historico.py` | FASE 9 | Limpio | OK |
| `perfiles/q01_2026.py` | FASE 9 | Limpio | OK |
| `perfiles/q02_2026.py` | FASE 9 | Limpio | OK |
| `perfiles/q04_2025.py` | FASE 9 | Limpio | OK |

### Base de datos

| Objeto | Estado esperado | Estado confirmado |
|---|---|---|
| `TABLE_PRIVILEGES` para `django_user` | Solo `etl_runs`: INSERT, SELECT, UPDATE | Confirmado |
| EXECUTE en SPs internos (`sp_etl_base_*`, `sp_etl_validar`) | 0 grants | Confirmado: 0 |
| EXECUTE en SPs autorizados | 9 PROCEDURE | Confirmado: 9 |
| EXECUTE en funciones | 7 FUNCTION | Confirmado: 7 |

---

## verify.sh — resultado completo

```
============================================================
IACT-db — Verificación completa
============================================================

  MariaDB:    127.0.0.1:3306 / ivr_legacy
  PostgreSQL: 127.0.0.1:5432 / iact_analytics

1/8 Variables de entorno (.env)         — 10 OK
2/8 Herramientas CLI                    —  4 OK
3/8 MariaDB conectividad                —  1 OK
3b/8 MariaDB schema ivr_legacy          —  6 OK
    Tablas analíticas completas (5/5)
    Funciones de utilidad completas (7/7)
    SPs ETL presentes: 5
    SPs Reporte presentes: 7
    GRANT EXECUTE OK (9 PROCEDURE, 7 FUNCTION)
    Tablas históricas presentes: 6
4/8 PostgreSQL conectividad             —  1 OK
5/8 Django → ivr_legacy (CNST-003)      —  2 OK
    CNST-003: django_user es READ-ONLY en ivr_legacy
6/8 Django → iact_analytics            —  2 OK
7/8 tbl_temp_prueba_ivr                 —  1 OK

OK:           27
Advertencias: 0
Errores:      0
EXIT:         0
```

---

## Resumen de cierre — todos los bugs del catálogo

| Bug | Severidad | Descripción | Fase | Estado |
|---|---|---|---|---|
| BUG-001 | ALTA | `utils/core.sh` — `break` sin loop | FASE 1 | RESUELTO |
| BUG-002 | ALTA | `sp_etl_pipeline.sql` — handler PASO 5 no actualiza `v_maestro_id` | FASE 4 | RESUELTO |
| BUG-003 | ALTA | `setup.sh` — verificación CNST-003 usa `USER_PRIVILEGES` | FASE 8 | RESUELTO |
| BUG-004 | MEDIA | `sp_rpt_reportes.sql` — división por cero silenciosa | FASE 5 | RESUELTO |
| BUG-005 | MEDIA | `backup_ivr_legacy.sh` — `TABLES=$(...)` sin `|| true` | FASE 2 | RESUELTO |
| BUG-006 | MEDIA | `backup_ivr_legacy.sh` — `SKIP_GRANT=$(...)` sin `|| true` | FASE 2 | RESUELTO |
| BUG-007 | BAJA | `utils/core.sh` — SC2155 `local backup=$(...)` | FASE 1 | RESUELTO |
| BUG-008 | BAJA | `utils/provisioning.sh` — SC2155 `export PROJECT_ROOT=$(...)` | FASE 1 | RESUELTO |
| BUG-009 | BAJA | `ssl.sh` — archivos temporales con rutas fijas en `/tmp` | FASE 3 | RESUELTO |
| BUG-010 | INFORMATIVO | `poblar_historico.py` — f-strings sin placeholders | FASE 9 | RESUELTO |
| BUG-011 | INFORMATIVO | perfiles proxy — `imported but unused` | FASE 9 | RESUELTO |
| CNST-003 código | — | `provision-mariadb.sh` — grants sobrantes en código | FASE 6 | RESUELTO |
| CNST-003 BD | — | Grants sobrantes en BD — 8 objetos | FASE 7 | RESUELTO |

**11 bugs resueltos. 2 correcciones de arquitectura de permisos. 0 deuda técnica pendiente.**

---

## Resumen de hallazgos fuera del plan — detectados durante ejecución

| Hallazgo | Fase | Descripción | Resolución |
|---|---|---|---|
| H-F3-001 | FASE 3 | BUG-009 tenía dos problemas: race condition + sin `trap` | `mktemp` + `trap EXIT INT TERM` |
| H-F4-001 | FASE 4 | BUG-002 solo se manifiesta en condición compuesta | Documentado, fix correcto |
| H-F5-001 | FASE 5 | BUG-004 real solo en 2 SPs; 5 correcciones son defensivas | Alcance ampliado por consistencia |
| H-F5-004 | FASE 5 | `DROP PROCEDURE` elimina GRANT EXECUTE en MariaDB | Procedimiento documentado |
| H-F6-003 | FASE 6 | SC2043 — loop de una iteración | Eliminado el loop |
| H-F7-002 | FASE 7 | EXECUTE sobrantes ya eliminados por FASE 5+6 | Solo verificación en T-7.3 |
| H-F8-002 | FASE 8 | `TABLE_PRIVILEGES` solo visible para el GRANTEE de la sesión | Cambiado a `my_root_silent` |
| H-F9-001 | FASE 9 | `import date` sin uso no estaba en el plan | Eliminado |
| H-F9-002 | FASE 9 | `# noqa: F401` no funciona en pyflakes puro | `__all__` + `# noqa` |
| H-F10-001 | FASE 10 | SC1090 en 3 archivos son preexistentes | Documentado, no corregir |

---

## Commits del plan de corrección (FASES 1-10)

| Commit | Fase | Descripción |
|---|---|---|
| `155fcce` | 1 | fix(utils): FASE 1 — corregir BUG-007, BUG-001, BUG-008 |
| `93437ae` | 2 | fix(backup): FASE 2 — corregir BUG-006 y BUG-005 |
| `5f2bf60` | 1+2 | docs(architecture): hallazgos FASE 1 y FASE 2 |
| `39c294f` | 3 | fix(adminer): FASE 3 — corregir BUG-009 en ssl.sh |
| `e24599f` | 4 | fix(pipeline): FASE 4 — corregir BUG-002 en sp_etl_pipeline.sql |
| `62559b6` | 5 | fix(reportes): FASE 5 — proteger divisiones con NULLIF |
| `e8f223f` | 6 | fix(provision): FASE 6 — corregir grants en provision-mariadb.sh |
| `0a1fca5` | 7 | docs(architecture): hallazgos FASE 7 — REVOKE grants sobrantes |
| `0cadf1a` | 8 | fix(setup): FASE 8 — corregir BUG-003 en setup.sh |
| `2892559` | 9 | fix(python): FASE 9 — corregir BUG-010 y BUG-011 en Python |
