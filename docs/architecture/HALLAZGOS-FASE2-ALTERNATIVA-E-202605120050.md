# Hallazgos — Ejecución FASE 2 (eliminación código muerto)

**Versión:** 1.0.0  
**Fecha:** 2026-05-11  
**Plan de referencia:** `PLAN-ALTERNATIVA-E-CONSOLIDADO-202605120030.md` FASE 2  
**Prerequisito completado:** FASE 1 — commit `f4a9e98`  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo |
|---|---|---|---|
| T-2.1 | `postgres/install.sh`: eliminar `configure_postgresql()` | COMPLETO | — |
| T-2.2 | `postgres/install.sh`: eliminar `_apply_iact_postgres_config()` | COMPLETO | — |
| T-2.3 | `postgres/install.sh`: eliminar `set_postgres_password()` + `main()` + `require_vars` | COMPLETO | H-F2-001, H-F2-002 |
| T-2.4 | `mariadb/install.sh`: eliminar `configure_mariadb()` | COMPLETO | — |
| T-2.5 | `mariadb/install.sh`: eliminar `_apply_iact_mariadb_config()` | COMPLETO | — |
| T-2.6 | `mariadb/install.sh`: eliminar `secure_mariadb()` + llamada en `main()` | COMPLETO | H-F2-001, H-F2-003 |
| — | `schema_historico.sh`: actualizar comentario de referencia | COMPLETO | H-F2-004 |
| T-2.7 | `verify.sh` → 27 OK sin regresión | PASA | — |

---

## Hallazgos detectados durante la ejecución

### H-F2-001 — `set_postgres_password` y `secure_mariadb` aún estaban en `main()`

**Detectado en:** Pre-análisis de T-2.3 y T-2.6  
**Severidad:** ALTA  
**Estado:** RESUELTO en T-2.3 y T-2.6

El plan clasificaba `set_postgres_password` y `secure_mariadb` como funciones
en "capa incorrecta" (H-INST-001, H-INST-003), y el análisis de `main()` del
commit `21eb26e` las listaba como `en_main=0`. Sin embargo, la verificación
directa del estado real mostró:

```
set_postgres_password:  en_main=1  ← aún se llamaba desde main()
secure_mariadb:         en_main=1  ← aún se llamaba desde main()
```

La clasificación anterior fue correcta para el análisis de capa, pero el
estado de `main()` no se actualizó correctamente en el documento. En la
ejecución real, además de eliminar la función, se debía eliminar la llamada
en `main()` y el bloque de error correspondiente.

Si se hubiera eliminado solo la función sin quitar la llamada, el script
habría fallado con `command not found` en tiempo de ejecución.

---

### H-F2-002 — `POSTGRES_PASSWORD` en `require_vars` quedaba huérfana

**Detectado en:** Pre-análisis de T-2.3  
**Severidad:** MEDIA  
**Estado:** RESUELTO en T-2.3

```bash
# postgres/install.sh antes:
require_vars POSTGRES_VERSION POSTGRES_PASSWORD
```

`POSTGRES_PASSWORD` era requerida por `set_postgres_password()`. Al eliminar
esa función, `require_vars` la seguía exigiendo sin que ninguna función del
archivo la usara. Esto producía un fallo en instalaciones donde solo se
provee `POSTGRES_VERSION` en `.env` (el mínimo necesario para install.sh).

**Resolución:** `require_vars` se actualizó a `require_vars POSTGRES_VERSION`.

**Nota sobre `DB_MARIADB_ROOT_PASSWORD` en `mariadb/install.sh`:**
Esta variable SÍ se mantiene en `require_vars` de `install.sh` porque
`_ensure_correct_mariadb_version()` la usa al detectar la versión instalada.
No es huérfana.

---

### H-F2-003 — Doble mención en `main()` de mariadb: comentarios referencian el nombre

**Detectado en:** Verificación post-T-2.6  
**Severidad:** BAJA (informativo)  
**Estado:** DOCUMENTADO — no requiere acción adicional

El grep `secure_mariadb` en el `main()` de `mariadb/install.sh` producía
falsos positivos porque la función aparecía en comentarios de documentación:

```bash
# secure_mariadb() fue movida a config.sh/_secure_mariadb().
# realiza en config.sh/_secure_mariadb() — capa CONFIG, no INSTALL.
```

La verificación correcta es filtrar líneas que no son comentarios:
```bash
grep "secure_mariadb" | grep -v "^    #\|^#"
# → vacío = no se llama, solo se menciona en comentarios
```

---

### H-F2-004 — `schema_historico.sh` referenciaba `install.sh` para `secure_mariadb`

**Detectado en:** Búsqueda exhaustiva de referencias externas  
**Severidad:** BAJA  
**Estado:** RESUELTO

```bash
# schema_historico.sh L48-49 antes:
#   · MariaDB instalado y securizado via provisioners/mariadb/install.sh
#     (install.sh ejecuta secure_mariadb() que establece password root válida).
```

Con `secure_mariadb()` movida a `config.sh/_secure_mariadb()`, el comentario
apuntaba a la ubicación incorrecta. Un desarrollador que siguiera esta
referencia no encontraría la función donde el comentario decía.

**Resolución:** Actualizado a:
```bash
#   · MariaDB instalado y securizado via provisioners/mariadb/config.sh
#     (config.sh ejecuta _secure_mariadb() que establece password root válida).
```

---

## Líneas eliminadas — resultado final

| Archivo | Antes | Después | Eliminadas |
|---|---|---|---|
| `postgres/install.sh` | 418 | 260 | 158 |
| `mariadb/install.sh` | 506 | 350 | 156 |
| `schema_historico.sh` | 600 | 600 | 0 (solo comentario) |
| **Total** | **1524** | **1210** | **314** |

Las 314 líneas eliminadas corresponden a:

**PostgreSQL:**
- `configure_postgresql()`: 106 líneas (pg_hba.conf + postgresql.conf + restart — lógica incorporada en config.sh en FASE 1)
- `_apply_iact_postgres_config()`: 27 líneas (idéntica a la de config.sh — H-DEAD-006)
- `set_postgres_password()` + llamada en main(): 12 + 4 líneas = 16 líneas (movida a config.sh/_secure_postgres en FASE 1)
- Comentarios asociados a las funciones eliminadas: ~9 líneas

**MariaDB:**
- `configure_mariadb()`: 58 líneas (bind-address + AIO — lógica incorporada en config.sh en FASE 1)
- `_apply_iact_mariadb_config()`: 29 líneas (lógica incorporada en config.sh/_apply_iact_mariadb_config en FASE 1)
- `secure_mariadb()` + llamada en main(): 46 + 4 líneas = 50 líneas (movida a config.sh/_secure_mariadb en FASE 1)
- Comentarios asociados: ~19 líneas

---

## Estado de los hallazgos del plan tras FASE 2

| Hallazgo | Descripción | Estado |
|---|---|---|
| H-INST-001 | `secure_mariadb()` en capa incorrecta | RESUELTO — T-2.6 |
| H-INST-002 | 220 líneas de código muerto en install.sh | RESUELTO — T-2.1..T-2.6 |
| H-INST-003 | `set_postgres_password()` en capa incorrecta | RESUELTO — T-2.3 |
| H-F2-001 | `set_postgres_password` y `secure_mariadb` aún en `main()` | RESUELTO — T-2.3, T-2.6 |
| H-F2-002 | `POSTGRES_PASSWORD` huérfana en `require_vars` de `install.sh` | RESUELTO — T-2.3 |
| H-F2-003 | grep de `secure_mariadb` en main() producía falso positivo | DOCUMENTADO |
| H-F2-004 | `schema_historico.sh` referenciaba `install.sh` para `secure_mariadb` | RESUELTO |
