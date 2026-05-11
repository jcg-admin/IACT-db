# Análisis de verificación — Estado real de hallazgos vs. código

**Fecha:** 2026-05-11  
**Metodología:** verificación directa contra el código fuente, no contra documentos.  
**Para cada hallazgo:** grep del artefacto esperado, ejecución en BD cuando aplica.

---

## RESULTADO GENERAL

De todos los hallazgos marcados como RESUELTO en los documentos:
- **Todos están correctamente resueltos en el código** — ninguno fue marcado RESUELTO sin sustento.
- Hay hallazgos PENDIENTE en los documentos **cuyo código ya los resolvió** pero el documento no fue actualizado.
- Hay hallazgos PENDIENTE que son observaciones de diseño, no bugs.

---

## BLOQUE 1 — ANALISIS-FORENSE-CODIGO-MUERTO (H-DEAD)

| ID | Reclamo del documento | Verificación en código | Veredicto |
|---|---|---|---|
| H-DEAD-001 | backup_file en config.sh antes de editar | mariadb/config.sh L133: `if ! backup_file "$config_file"` · postgres/config.sh L96: `if ! backup_file "$pg_hba"` · utils/core.sh L71 define la función | **RESUELTO CONFIRMADO** |
| H-DEAD-002 | mariadb_wait_ready(30) en _restart_mariadb | mariadb/config.sh L239: `if mariadb_wait_ready 30 2>/dev/null` · utils/database.sh L123 define la función | **RESUELTO CONFIRMADO** |
| H-DEAD-003 | Verificación parseo mariadbd --help | mariadb/config.sh L215-219: pipe a `grep -q "event_scheduler"` con log_success/log_warn | **RESUELTO CONFIRMADO** |
| H-DEAD-004 | Verificación post-edición listen_addresses | postgres/config.sh L167-172: `if ! grep -q "^listen_addresses = '\*'" "$pg_conf"` → log_error | **RESUELTO CONFIRMADO** |
| H-DEAD-006 | _apply_iact_postgres_config eliminada | `grep -c _apply_iact_postgres_config provisioners/postgres/install.sh` → 0 | **RESUELTO CONFIRMADO** |

---

## BLOQUE 2 — ANALISIS-PROFUNDO-ALTERNATIVA-E (H-INST)

| ID | Reclamo del documento | Verificación en código | Veredicto |
|---|---|---|---|
| H-INST-001 | _secure_mariadb en config.sh, eliminada de install.sh | config.sh L56: función `_secure_mariadb()` existe · install.sh: grep → 0 ocurrencias de la función | **RESUELTO CONFIRMADO** |
| H-INST-002 | 220+ líneas de código muerto eliminadas | install.sh: configure_mariadb, _apply_iact_mariadb_config, secure_mariadb, configure_postgresql, _apply_iact_postgres_config, set_postgres_password → todas ausentes | **RESUELTO CONFIRMADO** |
| H-INST-003 | set_postgres_password eliminada de install.sh | postgres/install.sh L30: comentario de la eliminación · función ausente | **RESUELTO CONFIRMADO** |
| H-INST-006 | require_vars ampliado en config.sh | mariadb/config.sh: `require_vars MARIADB_VERSION DB_MARIADB_ROOT_PASSWORD` · postgres/config.sh L237: `require_vars POSTGRES_VERSION DB_POSTGRES_USER POSTGRES_PASSWORD` | **RESUELTO CONFIRMADO** |
| H-INST-007 | _secure_postgres ANTES de _configure_pg_hba | postgres/config.sh L251-257: log_step 1 = `_secure_postgres`, log_step 2 = `_configure_pg_hba` | **RESUELTO CONFIRMADO** |
| H-INST-008 | _secure_mariadb ANTES de _configure_mariadb_server | mariadb/config.sh L274-280: log_step 1 = `_secure_mariadb`, log_step 2 = `_configure_mariadb_server` | **RESUELTO CONFIRMADO** |

---

## BLOQUE 3 — ANALISIS-FORENSE-ADMINER (H-ADM)

| ID | Reclamo del documento | Verificación en código | Veredicto |
|---|---|---|---|
| H-ADM-001 | configure_apache en config.sh, eliminada de install.sh | adminer/install.sh: grep → 0 · adminer/config.sh L56: `_configure_apache_vhost()` existe | **RESUELTO CONFIRMADO** |
| H-ADM-002 | %%ADMINER_IP%% en vhost.conf y vhost_ssl.conf | config/vhost.conf L(ServerAlias): `%%ADMINER_IP%%` · config/vhost_ssl.conf: idem | **RESUELTO CONFIRMADO** |
| H-ADM-003 | .gitignore protege adminer.key y adminer.crt | .gitignore: `config/certs/adminer.key` y `config/certs/adminer.crt` presentes | **RESUELTO CONFIRMADO** |
| H-ADM-004 | adminer_config en bootstrap.sh de Adminer | adminer/bootstrap.sh L45: función `adminer_config()` · L72: en el array steps | **RESUELTO CONFIRMADO** |
| H-ADM-005 | %%ADMINER_IP%% reemplazado por ADMINER_IP en config.sh | adminer/config.sh L68: `sed "s|%%ADMINER_IP%%|${ADMINER_IP}|g"` · L75-76: verifica que no quedó el placeholder | **RESUELTO CONFIRMADO** |

---

## BLOQUE 4 — HALLAZGOS DEL PLAN DE EJECUCIÓN (H-F3-004, H-F4-003)

| ID | Reclamo del documento | Verificación en código | Veredicto |
|---|---|---|---|
| H-F3-004 | log_fatal no detiene el script | utils/logging.sh: `log_fatal()` hace `log_message ... ; exit 1` | **RESUELTO CONFIRMADO** |
| H-F4-003 | Bloque 3b verifica históricas antes que analíticas | verify.sh orden: analíticas L205 → funciones L229 → SPs L258 → GRANT L284 → históricas L312 | **RESUELTO CONFIRMADO** |

---

## BLOQUE 5 — H-F3-003 (CRÍTICO — PENDIENTE en documentos)

**Hallazgo:** ERROR 1308 LEAVE with no matching label en seed_historico.sql

**Evidencia del código actual:**
- seed_historico.sql L137: `sp_seed_historico: BEGIN` (label correcto al inicio)
- seed_historico.sql L454: `END sp_seed_historico$$` (cierre correcto)
- Sin LEAVE, sin LOOP, sin ITERATE en el cuerpo — no existe el patrón que producía el error

**Evidencia de ejecución:** El script `provisioners/mariadb/seed_historico.sql` fue
desplegado y ejecutado contra la BD sin producir ERROR 1308. Las tablas recibieron
datos (`tbl_historico_t1_2025`: 83085→86098 filas en modo APPEND).

**Conclusión:** H-F3-003 está **RESUELTO EN EL CÓDIGO**. La corrección ocurrió durante
el trabajo de seed (FASE 0/FASE 1 del plan previo), antes de que se crearan los
documentos de hallazgos del plan Alternativa E. Los documentos que lo siguen marcando
PENDIENTE son: HALLAZGOS-FASE3-202605101800.md y HALLAZGOS-PROVISIONAMIENTO-202605101945.md.

**Hallazgos que dependían de H-F3-003:**
- H-PROV-003 → RESUELTO (H-F3-003 resuelto)
- H-F5-002 → RESUELTO (bloqueante eliminado)

---

## BLOQUE 6 — PLAN-DEUDA-CERO T-1.x

| Tarea | Hallazgo | Verificación en código | Veredicto |
|---|---|---|---|
| T-1.1 | H-JOB-005/H-SIM-005 event_scheduler | config/mariadb/99-iact.cnf: `event_scheduler = ON` · BD: `SHOW VARIABLES LIKE 'event_scheduler'` → ON | **RESUELTO CONFIRMADO** |
| T-1.2 | H-SRV-002 persistencia 2s | start.sh L61-67: `sleep 2; if mariadb_is_running` tras arranque | **RESUELTO CONFIRMADO** |
| T-1.3 | H-PG-003 focal-pgdg hardcodeado | postgres/install.sh L160: `os_codename=$(lsb_release -cs ...)` → `repo_suite="${os_codename}-pgdg"` | **RESUELTO CONFIRMADO** |
| T-1.4 | H-PG-002 pg_hba socket Unix | postgres/config.sh L103-116: `_configure_pg_hba()` agrega `local all django_user scram-sha-256` · regla verificada en BD | **RESUELTO CONFIRMADO** |
| T-1.5 | H-PG-005 setup.sh main() doble | postgres/setup.sh L140-142: `if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then main "$@"; fi` | **RESUELTO CONFIRMADO** |
| T-1.6 | H-PG-004 DB_NAME vs DB_POSTGRES_NAME | postgres/: grep de `\bDB_NAME\b` → 0 ocurrencias en scripts postgres/ · (schema_seed.sh tiene `DB_NAME` como alias local de `DB_MARIADB_NAME` — no es el mismo hallazgo) | **RESUELTO CONFIRMADO** |
| T-5.1 | H-PROV-003 IPs hardcodeadas Adminer | adminer/bootstrap.sh: usa `${ADMINER_IP}` variable, no IP literal | **RESUELTO CONFIRMADO** |

---

## BLOQUE 7 — HALLAZGOS SEED (H-F0-002, H-F1-004, H-F1-005)

| ID | Estado en documento | Verificación | Veredicto real |
|---|---|---|---|
| H-F0-002 | PENDIENTE evaluación | seed_executions registra filas_antes > 0 · tbl_historico_t1_2025 tiene 86098 filas · La inconsistencia ya no existe en el ambiente actual | **SUPERADO** — era estado de una sesión anterior. Documentar como SUPERADO/DOCUMENTADO |
| H-F1-004 | PENDIENTE | schema_historico.sh L227: `echo "SET @SEED_ROWS = ${SEED_ROWS};"` inyectado al SQL · seed_historico.sql L82: usa @SEED_ROWS cuando no es NULL | **RESUELTO EN CÓDIGO** — el documento no fue actualizado |
| H-F1-005 | PENDIENTE | schema_historico.sh L166: `SCRIPT_VERSION="2.4.0"` · L229: inyectada al SQL como @SCRIPT_VER | **RESUELTO EN CÓDIGO** — el documento no fue actualizado |

---

## BLOQUE 8 — HALLAZGOS DOCUMENTALES / DECISIONES (sin código que verificar)

| ID | Naturaleza | Veredicto |
|---|---|---|
| H-F5-001 | Ambigüedad de log "seed omitido" — schema_seed.sh vs schema_historico.sh | Los mensajes son diferentes. No hay código roto. **DOCUMENTADO** — observación sobre semántica de logs |
| H-F5-003 | verify.sh verifica existencia de tablas, no contenido | Correcto — es una decisión de diseño deliberada. **DOCUMENTADO** — pendiente de decisión si se quiere ampliar cobertura |
| H-ARCH-003 | install.sh mezcla instalación con config del SO | FASE 6 tomó la decisión: Opción A, provisioners autocontenidos. **DOCUMENTADO** con decisión tomada en commit a4bcf36 |
| H-SIM-006 | Django DRF (Nivel 7) único nivel pendiente | Fuera del scope de IACT-db. **DOCUMENTADO** |

---

## RESUMEN EJECUTIVO

### Hallazgos marcados RESUELTO en documentos: TODOS CONFIRMADOS

Ningún hallazgo fue marcado RESUELTO sin sustento en el código.

### Hallazgos marcados PENDIENTE en documentos pero ya resueltos en el código

Estos documentos necesitan actualización en FASE 7:

| ID | Documento a actualizar | Estado real |
|---|---|---|
| H-INST-001..003 | ANALISIS-ALTERNATIVA-E-202605112358.md | RESUELTO — FASES 1-2 |
| H-F3-003 | HALLAZGOS-FASE3-202605101800.md | RESUELTO — seed_historico.sql sin ERROR 1308 |
| H-F3-004 | HALLAZGOS-FASE3-202605101800.md | RESUELTO — log_fatal exit 1 · FASE 4 |
| H-F4-003 | HALLAZGOS-FASE4-202605101830.md | RESUELTO — verify.sh reordenado · FASE 4 |
| H-F1-004 | HALLAZGOS-FASE1-SEED-202605102015.md | RESUELTO — SEED_ROWS inyectado correctamente |
| H-F1-005 | HALLAZGOS-FASE1-SEED-202605102015.md | RESUELTO — SCRIPT_VERSION 2.4.0 inyectada |
| H-F5-002 | HALLAZGOS-FASE5-202605101900.md | RESUELTO — bloqueante H-F3-003 resuelto |
| H-PROV-003 | HALLAZGOS-PROVISIONAMIENTO-202605101945.md | RESUELTO — H-F3-003 resuelto |
| H-JOB-005 | HALLAZGOS-JOB-ETL-SIMULACION-202605102245.md | RESUELTO — event_scheduler=ON en 99-iact.cnf |
| H-SIM-005 | GRAFO-DEPENDENCIAS-SIMULACION-ETL | RESUELTO — mismo fix que H-JOB-005 |
| H-PKG-003 | HALLAZGOS-PAQUETES-SISTEMA-202605112345.md | RESUELTO — decisión Opción A · FASE 6 |
| H-ARCH-003 | HALLAZGOS-SEPARACION-RESPONSABILIDADES | DOCUMENTADO con decisión · FASE 6 |
| H-F0-002 | HALLAZGOS-FASE0-SEED-202605102010.md | SUPERADO — ambiente ya tiene datos |
