# `provisioners/mariadb/backup_ivr_legacy.sh`

**Requiere root:** Sí  
**Genera por ejecución:** `backups/<timestamp>.sql.gz` + `backups/<timestamp>.md5`

---

## Propósito

Backup completo de `ivr_legacy` con `mysqldump` + compresión `gzip -6`.
Detecta automáticamente el estado de `skip_grant_tables`, maneja opciones
de `mysqldump` compatibles con el entorno y registra hallazgos en
`backups/<timestamp>-hallazgos.md`.

---

## Uso

```bash
sudo bash provisioners/mariadb/backup_ivr_legacy.sh
```

---

## Funciones internas

| Función | Propósito |
|---|---|
| `log(msg)` | Logging con timestamp |
| `die(msg)` | Error fatal con mensaje |
| `root_exec(args...)` | Ejecuta mysql como root |
| `root_ping()` | Verifica conectividad root |
| `backup_exec(args...)` | Ejecuta mysqldump con manejo de errores |
| `registrar_hallazgo(id, cat, desc, sol)` | Agrega hallazgo al documento |
| `_generar_hallazgos()` | Genera el documento de hallazgos post-backup |

---

## Protecciones (BUG-005 y BUG-006, FASE 2)

```bash
SKIP_GRANT=$(root_exec ...) || SKIP_GRANT=""   # BUG-006
TABLES=$(root_exec ...)     || { log "WARN"; TABLES=""; }  # BUG-005
```

Sin `|| true` / `|| {...}`, `set -euo pipefail` terminaría el script
silenciosamente si la BD no responde durante la consulta.
