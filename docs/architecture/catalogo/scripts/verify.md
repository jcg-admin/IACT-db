# `verify.sh`

**Requiere root:** No  
**Salida:** 27 checks en 7 secciones

---

## Propósito

Verifica el estado completo del entorno IACT-db. Diseñado para ejecutarse
después de cualquier cambio de configuración o como health check en CI.

---

## Uso

```bash
bash verify.sh
```

---

## Secciones verificadas

| Sección | Checks | Descripción |
|---|---|---|
| 1/8 Variables .env | 10 | Variables requeridas presentes |
| 2/8 CLI tools | 4 | mysql, psql, mysqladmin, pg_isready disponibles |
| 3/8 MariaDB conectividad | 1 | Socket Unix activo |
| 3b/8 Schema ivr_legacy | 6 | Tablas, funciones, SPs, EXECUTE grants, tablas históricas |
| 4/8 PostgreSQL | 1 | pg_isready responde |
| 5/8 Django → ivr_legacy | 2 | Conexión TCP + CNST-003 READ-ONLY |
| 6/8 Django → iact_analytics | 2 | Conexión + permisos DDL para migrate |
| 7/8 tbl_temp_prueba_ivr | 1 | 3000 registros disponibles |

---

## Criterio de éxito

```
OK:           27
Advertencias: 0
Errores:      0
EXIT:         0
```
