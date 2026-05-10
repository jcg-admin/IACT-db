# Hallazgos del backup — 2026-05-07T030931

**Script:** `provisioners/mariadb/backup_ivr_legacy.sh`
**Backup generado:** `ivr_legacy_2026-05-07T030931.sql.gz`
**Total hallazgos:** 4
**Severidad maxima:** MEDIA

---

## H01 — MariaDB no estaba corriendo al iniciar el backup [MEDIA]

El proceso mariadbd no persistio entre sesiones. Fue necesario arrancarlo.\nTiempo de arranque: 2s tras 1 intentos de conexion.\nEn produccion MariaDB corre como servicio systemd y esto no ocurre.\nReferencia: BK-001 / HALLAZGOS-ENTORNO.md H-001-03

---

## H02 — skip_grant_tables activo — GRANTS no se incluyen en el dump [MEDIA]

MariaDB corre con --skip-grant-tables. El dump NO contiene usuarios ni permisos.\nNo puede usarse para restaurar autenticacion en produccion.\nPara respaldar GRANTS se requiere acceso root con autenticacion activa.\nReferencia: BK-003

---

## H03 — Estadisticas InnoDB desactualizadas en tbl_historico_t1_2025 [BAJA]

table_rows reporta 2 pero COUNT(*) real es 50000.\nLas estadisticas InnoDB no estan actualizadas en este entorno.\nEl log muestra el COUNT(*) real como valor definitivo.\nReferencia: BK-002

---

## H04 — Estadisticas InnoDB desactualizadas en tbl_historico_t2_2026 [BAJA]

table_rows reporta 0 pero COUNT(*) real es 23100.\nLas estadisticas InnoDB no estan actualizadas en este entorno.\nEl log muestra el COUNT(*) real como valor definitivo.\nReferencia: BK-002

---

