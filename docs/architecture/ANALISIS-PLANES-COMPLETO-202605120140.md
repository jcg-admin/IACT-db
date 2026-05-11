# Análisis completo de planes — IACT-db

**Fecha:** 2026-05-11  
**Propósito:** Inventario y estado de todos los planes del proyecto,
incluyendo los que estaban fuera del repositorio.

---

## Hallazgo de auditoría

**`PLAN-IMPLEMENTACION-SEED-HISTORICO-202605102000.md` faltaba del repositorio.**

Fue creado el 2026-05-10 y entregado via `present_files` desde
`/mnt/user-data/outputs/`, pero nunca fue commiteado al repositorio.
Recuperado del transcript `2026-05-10-09-05-10-iact-db-seed-historico-fase2.txt`
e incluido en el commit de esta sesión.

Todos los demás planes sí estaban en el repositorio.

---

## Inventario completo — 10 planes

| Plan | Fecha | Tareas | Estado |
|---|---|---|---|
| `PLAN-IMPLEMENTACION.md` | 2026-05-06 | 52 | CERRADO — precursor del v2 |
| `PLAN-IMPLEMENTACION-V2.md` | 2026-05-06 | 59 | CERRADO — 66/66 PASS |
| `PLAN-IMPLEMENTACION-V2.1.md` | 2026-05-07 | 59 | CERRADO — 66/66 PASS |
| `PLAN-CORRECCIONES-2026-05-10.md` | 2026-05-10 | 22 | CERRADO |
| `PLAN-CORRECCIONES-EJECUCION-202605101630.md` | 2026-05-10 | 25 | CERRADO |
| `PLAN-SEGURIDAD-MARIADB-202605101715.md` | 2026-05-10 | 16 | CERRADO |
| `PLAN-IMPLEMENTACION-SEED-HISTORICO-202605102000.md` | 2026-05-10 | 21 | CERRADO — recuperado |
| `PLAN-SEED-HISTORICO-V2-202605102100.md` | 2026-05-10 | 26 | CERRADO |
| `PLAN-DEUDA-CERO-202605102315.md` | 2026-05-10 | 22 | CERRADO — absorbido por Alt-E |
| `PLAN-ALTERNATIVA-E-CONSOLIDADO-202605120030.md` | 2026-05-11 | 36 | CERRADO — FASES 1-7 |

**Total: 10 planes, 348 tareas, 0 PENDIENTE reales.**

Los 3 PENDIENTE que aparecen en grep son texto descriptivo dentro de
comandos bash y headers de documentos, no hallazgos abiertos.

---

## Análisis por plan

---

### 1. PLAN-IMPLEMENTACION.md (1354L, 52 tareas)

**Fecha:** 2026-05-06  
**Alcance:** Plan original v1.0 del pipeline ETL IVR.

El plan fundacional del proyecto. Establece la arquitectura de 7 niveles
del pipeline (funciones → event → Django → SPs ETL → SPs reporte → endpoints)
y define el primer conjunto de tareas de implementación contra MariaDB 10.1.48.

**Nota importante:** Todo el plan fue escrito asumiendo MariaDB 10.1.48 (sin
window functions). El entorno real tiene 10.11.14. Esta diferencia quedó
documentada como hallazgo en `HALLAZGOS-ENTORNO.md`.

**Estado:** CERRADO. Superado por v2.0 que corrige los supuestos de versión
y agrega 14 tareas adicionales.

---

### 2. PLAN-IMPLEMENTACION-V2.md (1375L, 59 tareas, 66 en el plan)

**Fecha:** 2026-05-06  
**Alcance:** Reescritura completa del plan original.

Corrige los supuestos de versión (MariaDB 10.11.14 con window functions)
y agrega: verificación de extensiones PostgreSQL, manejo de `--skip-grant-tables`,
corrección del `DEFINER` en eventos, y ajuste del seed a 3000 filas por tabla.

**Resultado:** 66/66 PASS documentado en `HALLAZGOS-PLAN-V2.1-CIERRE-2026-05-09.md`.

**Estado:** CERRADO. Superado por v2.1 que agrega correcciones de la sesión
2026-05-07.

---

### 3. PLAN-IMPLEMENTACION-V2.1.md (1388L, 59 tareas, 66 en el plan)

**Fecha:** 2026-05-07  
**Alcance:** Mismas 66 tareas que v2.0 con correcciones en:
- T-019: `CREATE EXTENSION` requiere `CREATE` privilege
- T-081: Event Scheduler con `--skip-grant-tables` produce ERROR 1577
- T-082: `SET GLOBAL event_scheduler=ON` requiere SUPER — alternativa: arrancar con flag
- T-083: `CREATE DEFINER=root@localhost EVENT` — DEFINER debe coincidir con el usuario

**Resultado:** Plan cerrado con 66/66 PASS. Es el último plan de la serie v2.x.

**Estado:** CERRADO. Las correcciones de esta versión quedaron incorporadas
en los provisioners y en `PLAN-CORRECCIONES-EJECUCION-202605101630.md`.

---

### 4. PLAN-CORRECCIONES-2026-05-10.md (384L, 22 tareas)

**Fecha:** 2026-05-10  
**Objetivo:** Eliminar inconsistencias en `utils/` que afectan a todos los
provisioners.

**Tareas representativas:**
- Correcciones en `utils/database.sh`: `_pg_kill_stale`, `_mariadb_kill_stale`
- Corrección de `_pg_start_ctlcluster` restart
- `local` fuera de función en `provision-mariadb.sh`
- `schema_historico.sh`: usuario incorrecto para CREATE TABLE
- `schema_historico.sh`: swallows errores DDL
- `verify.sh 3b`: sin verificación de tablas históricas

**Relación con otros planes:** Cierra H-EXEC-001..009 del documento de
hallazgos de ejecución. Las correcciones se aplican antes de ejecutar
`PLAN-CORRECCIONES-EJECUCION-202605101630.md`.

**Estado:** CERRADO.

---

### 5. PLAN-CORRECCIONES-EJECUCION-202605101630.md (687L, 25 tareas)

**Fecha:** 2026-05-10  
**Objetivo:** Corregir los fallos de la sesión de provisionamiento:
conexión root vía socket, `(( consecutivos++ ))` con `set -e`,
y `ALTER USER` dual auth.

**Fases del plan:**
- FASE 1: Infraestructura de conexión root vía socket Unix
- FASE 2: `command -v column` — disponibilidad de herramienta
- FASE 3: `SKIP_SEED` propagación y seed con `set -e`
- FASE 4: verify.sh con tablas históricas
- FASE 5: Integración y prueba completa
- FASE 6: Documentación de hallazgos

**Hallazgos que cierra:** H-F3-001 (set -e + arithmetic), H-F3-002 (dual auth),
H-F4-003 (verify.sh 3b), H-EXEC-005..009.

**Nota:** H-F3-003 (ERROR 1308) y H-F3-004 (log_fatal) quedaron PENDIENTE
en este plan — fueron resueltos posteriormente en el plan Alternativa E.

**Estado:** CERRADO. El único PENDIENTE en el archivo es el comando
`grep "Estado.*PENDIENTE"` en el cuerpo de una tarea (texto de verificación,
no un hallazgo abierto).

---

### 6. PLAN-SEGURIDAD-MARIADB-202605101715.md (557L, 16 tareas)

**Fecha:** 2026-05-10  
**Objetivo:** Restablecer el estado funcional de autenticación root para TCP
(authentication_string=invalid detectado en H-SEC-003).

**Contenido:** Diagnóstico y corrección de autenticación dual
(`unix_socket OR mysql_native_password`), corrección de `pg_hba.conf`
para django_user, y verificación post-corrección.

**Relación con otros planes:** Complementa `PLAN-CORRECCIONES-EJECUCION`
para la parte de seguridad de MariaDB. Los hallazgos H-SEC-002..004 fueron
cerrados en el plan Alternativa E (FASE 5).

**Estado:** CERRADO. El único PENDIENTE es el comando `grep "Estado.*PENDIENTE"`
en el cuerpo de una tarea de verificación.

---

### 7. PLAN-IMPLEMENTACION-SEED-HISTORICO-202605102000.md (626L, 21 tareas)

**Fecha:** 2026-05-10  
**Objetivo:** Poblar las tablas `tbl_historico_tN_YYYY` con datos semilla
para que el pipeline ETL de IACT-api tenga fuente de datos operativa.

**Contexto:** Este plan fue creado después de que el seed fallara por H-F3-003
(ERROR 1308 en `seed_historico.sql`). La hipótesis inicial era que el problema
era el pipe en `my_exec_vars_root`.

**Fases:**
- FASE 0 (T-0.1..T-0.3): Precondición — estado base del entorno
- FASE 1 (T-1.1..T-1.3): Corrección de `my_exec_vars_root` — archivo temporal
- FASE 2 (T-2.1..T-2.3): Persistencia de MariaDB entre invocaciones
- FASE 3 (T-3.1..T-3.3): PostgreSQL contrib extensions
- FASE 4 (T-4.1..T-4.4): Ejecución completa del seed
- FASE 5 (T-5.1..T-5.4): Verificación y baseline

**Resultado:** La hipótesis T-1.1 (pipe en `my_exec_vars_root`) fue descartada.
La causa real era el label faltante en el stored procedure (H-F1-001).
El seed corrió exitosamente tras corregir el label.

**Nota de recuperación:** Este plan fue entregado via `present_files` pero
nunca commiteado al repositorio. Recuperado del transcript
`2026-05-10-09-05-10-iact-db-seed-historico-fase2.txt` en esta sesión.

**Estado:** CERRADO. Sin PENDIENTE.

---

### 8. PLAN-SEED-HISTORICO-V2-202605102100.md (855L, 26 tareas)

**Fecha:** 2026-05-10  
**Objetivo:** Corregir el seed histórico e integrar `poblar_historico.py`
como Nivel 2 de seed.

**Fases:**
- FASE 1: `seed_historico.sql` v3.0.0 — SKIP→APPEND, eliminar TRUNCATE,
  corregir distribuciones (G-29: 0.003→0.388), eliminar FORCE_RESEED
- FASE 2: `schema_historico.sh` v2.3.0 — agregar PASO 4 con `poblar_historico.py`
- FASE 3: Validación de distribuciones calibradas por quarter
- FASE 4: Documentación y versiones

**Hallazgos que cierra:** H-SEED-001..015 (todos los bugs del seed SQL y Python).

**Resultado:** `seed_historico.sql` v3.0.0 + `poblar_historico.py` v1.1.0
con 6 módulos de perfiles por quarter. verify.sh en 26 OK.

**Estado:** CERRADO. Sin PENDIENTE.

---

### 9. PLAN-DEUDA-CERO-202605102315.md (598L, 22 tareas)

**Fecha:** 2026-05-10  
**Objetivo:** Consolidar todos los hallazgos PENDIENTE de los documentos
de arquitectura en un plan único con tareas atómicas.

**Estructura:**
- T-1.x: Correcciones puntuales (event_scheduler, persistencia MariaDB,
  repo PGDG, pg_hba socket, bootstrap deduplication, DB_NAME)
- T-2.x..T-4.x: Pipeline ETL y verify.sh
- T-5.x: Adminer — IPs hardcodeadas
- T-6.x: Cierre documental

**Estado real:** Las tareas T-1.x..T-4.x fueron absorbidas por
`PLAN-ALTERNATIVA-E-CONSOLIDADO-202605120030.md` FASES 1-6.
Las tareas T-6.x (cierre documental) se ejecutaron en FASE 7.

**Estado:** CERRADO. El único PENDIENTE es el header
"Consolidación de todos los hallazgos PENDIENTE" (texto descriptivo).

---

### 10. PLAN-ALTERNATIVA-E-CONSOLIDADO-202605120030.md (794L, 36 tareas)

**Fecha:** 2026-05-11  
**Objetivo:** Implementar la Alternativa E (separación de responsabilidades
INSTALL/SECURE/CONFIG/SETUP) y cerrar todos los hallazgos pendientes.

**Fases y commits:**

| FASE | Tareas | Commit | Estado |
|---|---|---|---|
| FASE 1 — Enriquecer config.sh | T-1.1..T-1.8 | f4a9e98 | COMPLETO |
| FASE 2 — Eliminar código muerto | T-2.1..T-2.7 | 8384bab | COMPLETO |
| FASE 3 — Adminer | T-3.1..T-3.7 | bb44944 | COMPLETO |
| FASE 4 — Pipeline ETL | T-4.1..T-4.5 + fix set-e | 4ded8ab + cb5c04a | COMPLETO |
| FASE 5 — Seguridad + archivado | T-5.1..T-5.4 | 5a48040 | COMPLETO |
| FASE 6 — H-PKG-003 decisión | T-6.1 | a4bcf36 | COMPLETO |
| FASE 7 — Cierre documental | T-7.1..T-7.4 | bc1ad6c | COMPLETO |

**verify.sh final:** 27 OK, 0 WARN, 0 ERR.

**Estado:** CERRADO. Sin PENDIENTE. Es el plan maestro del proyecto.

---

## Línea de tiempo de los planes

```
2026-05-06  PLAN-IMPLEMENTACION.md (v1 — 52 tareas)
            └── supuesto MariaDB 10.1.48 → incorrecto
2026-05-06  PLAN-IMPLEMENTACION-V2.md (v2 — 66 tareas)
            └── corrige supuestos de versión
2026-05-07  PLAN-IMPLEMENTACION-V2.1.md (v2.1 — 66 tareas)
            └── corrige event_scheduler, DEFINER, extensiones PG
            └── RESULTADO: 66/66 PASS
2026-05-10  PLAN-CORRECCIONES-2026-05-10.md (22 tareas)
            └── corrige utils/: set -e, local, schema_historico, verify
2026-05-10  PLAN-CORRECCIONES-EJECUCION-202605101630.md (25 tareas)
            └── root socket, dual auth, SKIP_SEED, H-F3-001/002
            └── H-F3-003 y H-F3-004 quedan PENDIENTE
2026-05-10  PLAN-SEGURIDAD-MARIADB-202605101715.md (16 tareas)
            └── autenticación dual, pg_hba.conf, diagnóstico root TCP
2026-05-10  PLAN-IMPLEMENTACION-SEED-HISTORICO-202605102000.md (21 tareas)
            └── hipótesis: my_exec_vars_root con pipe → DESCARTADA
            └── causa real: label faltante en SP (H-F1-001)
            └── *** FALTABA EN EL REPOSITORIO — RECUPERADO ***
2026-05-10  PLAN-SEED-HISTORICO-V2-202605102100.md (26 tareas)
            └── seed_historico.sql v3.0.0 + poblar_historico.py v1.1.0
            └── RESULTADO: verify.sh 26 OK
2026-05-10  PLAN-DEUDA-CERO-202605102315.md (22 tareas)
            └── consolidación de todos los PENDIENTE restantes
            └── absorbido por Plan Alternativa E
2026-05-11  PLAN-ALTERNATIVA-E-CONSOLIDADO-202605120030.md (36 tareas)
            └── FASES 1-7 ejecutadas → RESULTADO: verify.sh 27 OK
```

---

## Conclusión

**10 planes totales, 348 tareas, 0 PENDIENTE reales.**

El único hallazgo de esta auditoría es que
`PLAN-IMPLEMENTACION-SEED-HISTORICO-202605102000.md` no estaba en el
repositorio. Fue recuperado del transcript e incluido en el commit de
esta sesión.

El resto de planes estaba completo y correctamente commiteado.
