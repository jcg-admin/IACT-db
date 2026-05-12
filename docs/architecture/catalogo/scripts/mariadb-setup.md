# `provisioners/mariadb/setup.sh`

**Requiere root:** Sí  
**Idempotente:** Sí

---

## Propósito

Crea la base de datos `ivr_legacy`, el usuario `django_user` y aplica los
grants base de CNST-003. Es el paso 2 del flujo de `provision-mariadb.sh`.

---

## Uso

```bash
sudo bash provisioners/mariadb/setup.sh
# O desde provision-mariadb.sh (recomendado)
```

---

## Pasos internos

| Paso | Descripción |
|---|---|
| 1/5 | Verificar acceso root a MariaDB via socket |
| 2/5 | Crear BD ivr_legacy (si no existe) |
| 3/5 | Crear/actualizar django_user en @% y @localhost |
| 4/5 | GRANT SELECT ON ivr_legacy.* (CNST-003) + CREATE/DROP en test_ivr_legacy |
| 5/5 | Verificar conexión TCP y socket, reportar estado CNST-003 |

---

## Verificación CNST-003

Consulta `TABLE_PRIVILEGES` como root (vía socket) para reportar qué tablas
tienen escritura directa. Diseñada para observabilidad, no enforcement.
Estado esperado post-provisión: `etl_runs: INSERT, UPDATE`.
