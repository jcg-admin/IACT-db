# Inventario completo — Planes y Hallazgos IACT-db

**Generado:** 2026-05-11  
**Propósito:** Auditoría previa a FASE 7. Estado real tal como aparece  
en cada documento — sin interpretar ni proyectar.  
**Commits del proyecto:**
- `f4a9e98` — FASE 1 (enriquecer config.sh)
- `8384bab` — FASE 2 (eliminar código muerto)
- `bb44944` — FASE 3 (Adminer)
- `4ded8ab` — FASE 4 (pipeline ETL + verify.sh)
- `cb5c04a` — FASE 4+ (fix set-e command substitution)
- `5a48040` — FASE 5 (seguridad + archivado + documentación)
- `a4bcf36` — FASE 6 (decisión H-PKG-003)

---

## SECCIÓN 1 — PLANES

---

### PLAN-ALTERNATIVA-E-CONSOLIDADO-202605120030.md (794L)

El plan maestro del proyecto. FASES 1-6 tienen commits. FASE 7 (cierre
documental) está pendiente de ejecución.

| FASE | Tareas | Estado en el plan |
|---|---|---|
| FASE 1 — Enriquecer config.sh | T-1.1..T-1.8 | Sin marcador de estado — ejecutada (commit f4a9e98) |
| FASE 2 — Eliminar código muerto | T-2.1..T-2.7 | Sin marcador de estado — ejecutada (commit 8384bab) |
| FASE 3 — Adminer | T-3.1..T-3.7 | Sin marcador de estado — ejecutada (commit bb44944) |
| FASE 4 — Pipeline ETL | T-4.1..T-4.5 | Sin marcador de estado — ejecutada (commits 4ded8ab + cb5c04a) |
| FASE 5 — Seguridad/archivado | T-5.1..T-5.4 | Sin marcador de estado — ejecutada (commit 5a48040) |
| FASE 6 — H-PKG-003 | T-6.1 | Sin marcador de estado — ejecutada (commit a4bcf36) |
| FASE 7 — Cierre documental | T-7.1..T-7.4 | PENDIENTE — no ejecutada |

**Nota:** La proyección `Baseline final esperado: ≥ 28 OK` es incorrecta.
El baseline real es 27 OK (documentado en H-F4-002 de HALLAZGOS-FASE4-ALTERNATIVA-E).

---

### PLAN-DEUDA-CERO-202605102315.md (595L)

Plan paralelo que consolidó hallazgos de múltiples documentos.
Las tareas T-2.x..T-4.x fueron absorbidas por el plan Alternativa E.

| Tarea | Descripción | Estado en el plan |
|---|---|---|
| T-1.1 | `my.cnf`: event_scheduler=ON | Sin marcador — verificar |
| T-1.2 | `start.sh`: verificar persistencia 2s post-arranque | Sin marcador — verificar |
| T-1.3 | `postgres/install.sh`: corregir repo PGDG (focal-pgdg) | Sin marcador — verificar |
| T-1.4 | `postgres/setup.sh`: regla socket Unix pg_hba.conf | Sin marcador — verificar |
| T-1.5 | `postgres/bootstrap.sh`: deduplicar main() | Sin marcador — verificar |
| T-1.6 | `postgres/bootstrap.sh`: DB_NAME vs DB_POSTGRES_NAME | Sin marcador — verificar |
| T-1.7 | `mariadb/install.sh`: instalar postgresql-contrib | Falso positivo — ya estaba |
| T-2.1..T-2.4 | provision-mariadb.sh, verify.sh, log_fatal | Absorbidas por FASE 4 |
| T-3.1..T-3.2 | schema_historico.sh socket, install.sh docs | Absorbidas por FASE 5 |
| T-4.1..T-4.2 | Archivar seed_historico_real.sql, FLUJO-ETL | Absorbidas por FASE 5 |
| T-5.1 | `adminer/bootstrap.sh`: IPs hardcodeadas | Sin marcador — verificar |
| T-6.1..T-6.6 | Cierre documental de hallazgos en otros docs | PENDIENTE — no ejecutado |

---

### PLAN-CORRECCIONES-2026-05-10.md (384L)

Plan de correcciones puntuales. Sin PENDIENTE reales (el único `PENDIENTE`
es parte de un comando grep en el cuerpo del documento).

---

### PLAN-CORRECCIONES-EJECUCION-202605101630.md (687L)

Similar al anterior. El `PENDIENTE` es un comando grep — no es un hallazgo.

---

### PLAN-SEGURIDAD-MARIADB-202605101715.md (557L)

El `PENDIENTE` es un comando grep — no es un hallazgo activo.

---

### PLAN-SEED-HISTORICO-V2, PLAN-IMPLEMENTACION*.md

Sin hallazgos PENDIENTE. Planes de referencia histórica.

---

## SECCIÓN 2 — HALLAZGOS

Leyenda de estados tal como aparecen en los documentos:
- **RESUELTO** = marcado explícitamente con ese texto
- **DOCUMENTADO** = reconocido, no requiere acción
- **PENDIENTE** = sin resolución registrada en el documento
- **PENDIENTE evaluación** = requiere decisión antes de actuar
- **PENDIENTE DECISIÓN** = decisión arquitectural pendiente

---

### ANALISIS-ALTERNATIVA-E-202605112358.md (349L)

Documento de análisis previo. La tabla al final tiene estado desactualizado
(escrita ANTES de que las FASES se ejecutaran).

| ID | Descripción breve | Severidad | Estado en doc |
|---|---|---|---|
| H-INST-001 | `secure_mariadb` en install.sh — capa incorrecta | ALTA | **PENDIENTE** ← desactualizado |
| H-INST-002 | 282L código muerto en install.sh | ALTA | **PENDIENTE** ← desactualizado |
| H-INST-003 | `set_postgres_password` en install.sh — capa incorrecta | ALTA | **PENDIENTE** ← desactualizado |
| H-INST-004 | bootstrap.sh ya tiene estructura de 4 pasos | INFO | DOCUMENTADO |
| H-INST-005 | 0 archivos nuevos necesarios | INFO | DOCUMENTADO |

**Nota:** Estos 3 hallazgos fueron resueltos en FASES 1-2 pero este documento
original nunca se actualizó. Es uno de los documentos objetivo de T-7.1.

---

### ANALISIS-FORENSE-ADMINER-202605120020.md (293L)

| ID | Descripción breve | Severidad | Estado en doc |
|---|---|---|---|
| H-ADM-001 | `configure_apache()` en install.sh — CONFIG mezclado con INSTALL | MEDIA | RESUELTO — T-3.4 + T-3.6 · bb44944 |
| H-ADM-002 | IP hardcodeada en vhost.conf y vhost_ssl.conf | ALTA | RESUELTO — T-3.1 + T-3.2 · bb44944 |
| H-ADM-003 | ssl.sh escribe certs dentro del repo | ALTA | RESUELTO — T-3.3 · bb44944 |
| H-ADM-004 | bootstrap.sh Adminer sin paso adminer_config | MEDIA | RESUELTO — T-3.5 · bb44944 |
| H-ADM-005 | ADMINER_IP no se usa en vhost.conf | ALTA | RESUELTO — T-3.1 · bb44944 |
| H-ADM-006 | cp para certs es correcto (no symlink) | INFO | DOCUMENTADO |

---

### ANALISIS-FORENSE-CODIGO-MUERTO-202605120010.md (423L)

| ID | Descripción breve | Severidad | Estado en doc |
|---|---|---|---|
| H-DEAD-001 | `backup_file` faltante en config.sh | ALTA | RESUELTO — T-1.1 + T-1.5 · f4a9e98 |
| H-DEAD-002 | `mariadb_wait_ready(30)` faltante en _restart_mariadb | ALTA | RESUELTO — T-1.2 · f4a9e98 |
| H-DEAD-003 | Verificación parseo mariadbd --help faltante | MEDIA | RESUELTO — T-1.3 · f4a9e98 |
| H-DEAD-004 | Verificación post-edición listen_addresses faltante | MEDIA | RESUELTO — T-1.6 · f4a9e98 |
| H-DEAD-005 | POSTGRES_REMOTE_CIDR con md5 — no recuperar | INFO | No recuperar |
| H-DEAD-006 | _apply_iact_postgres_config idéntica en install y config | INFO | RESUELTO — T-2.2 · 8384bab |
| H-DEAD-007 | restart vs reload PostgreSQL | INFO | No recuperar |

---

### ANALISIS-PROFUNDO-ALTERNATIVA-E-202605120001.md (582L)

| ID | Descripción breve | Severidad | Estado en doc |
|---|---|---|---|
| H-INST-001 | secure_mariadb() en capa incorrecta | ALTA | RESUELTO — T-1.4 + T-2.6 · f4a9e98 + 8384bab |
| H-INST-002 | 220L código muerto en install.sh | ALTA | RESUELTO — T-2.1..T-2.6 · 8384bab |
| H-INST-003 | set_postgres_password() en capa incorrecta | ALTA | RESUELTO — T-1.7 + T-2.3 · f4a9e98 + 8384bab |
| H-INST-004 | bootstrap.sh ya tiene la estructura correcta | INFO | Este análisis |
| H-INST-005 | 0 archivos nuevos necesarios | INFO | Este análisis |
| H-INST-006 | require_vars incompleto en config.sh | MEDIA | RESUELTO — T-1.4 + T-1.7 · f4a9e98 |
| H-INST-007 | Orden _secure_postgres ANTES de _configure_pg_hba | ALTA | RESUELTO — T-1.7 · f4a9e98 |
| H-INST-008 | Orden _secure_mariadb ANTES de _configure_mariadb_server | ALTA | RESUELTO — T-1.4 · f4a9e98 |

---

### HALLAZGOS-EJECUCION-2026-05-10.md (525L)

| ID | Estado en doc |
|---|---|
| H-EXEC-001..009 | Todos RESUELTO o POSITIVO/DOCUMENTADO |

---

### HALLAZGOS-FASE0-SEED-202605102010.md (320L)

| ID | Descripción breve | Severidad | Estado en doc |
|---|---|---|---|
| H-F0-001 | information_schema.table_rows reporta 0 para InnoDB | — | DOCUMENTADO |
| H-F0-002 | seed_executions registra 3000 filas pero tbl_historico tiene 0 | ALTA | **PENDIENTE evaluación** |
| H-F0-003 | vw_monitor_dias_semana no documentada en inventario | BAJA | DOCUMENTADO |
| H-F0-004 | sp_seed_historico no existe — DELIMITER roto | — | DOCUMENTADO |
| H-F0-005 | job_config.etl_historico deshabilitado | MEDIA | DOCUMENTADO |
| H-F0-006 | sp_etl_base_detalle lee tbl_historico via tabla dinámica | — | DOCUMENTADO |

---

### HALLAZGOS-FASE1-ALTERNATIVA-E-202605120040.md (169L)

Todos los hallazgos marcados RESUELTO con commit f4a9e98. Sin pendientes.

---

### HALLAZGOS-FASE1-DEUDA-CERO-202605112330.md (107L)

Cinco falsos positivos del plan. Todos marcados DOCUMENTADO. Sin pendientes.

---

### HALLAZGOS-FASE1-SEED-202605102015.md (324L)

| ID | Descripción breve | Severidad | Estado en doc |
|---|---|---|---|
| H-F1-001 | Causa ERROR 1308 era label faltante — diagnóstico incorrecto | CRÍTICA | RESUELTO |
| H-F1-002 | pipe + DELIMITER funciona en MariaDB 10.11 — hipótesis descartada | — | DOCUMENTADO |
| H-F1-003 | my_exec_vars_root con pipe es correcto | — | DOCUMENTADO |
| H-F1-004 | SEED_ROWS=100 ignorado — seed usa default 3000 | MEDIA | **PENDIENTE** |
| H-F1-005 | seed_executions.script_version reporta 2.0.0 en lugar de 2.2.0 | BAJA | **PENDIENTE** |
| H-F1-006 | t2_2026 recibe 1186 registros — proporcional | — | DOCUMENTADO |

---

### HALLAZGOS-FASE1-SEED-SQL-202605102015.md (338L)

Todos RESUELTO o DOCUMENTADO. Sin pendientes.

---

### HALLAZGOS-FASE2-202605101845.md (203L)

Todos DOCUMENTADO. Sin pendientes.

---

### HALLAZGOS-FASE2-ALTERNATIVA-E-202605120050.md (161L)

Todos RESUELTO o DOCUMENTADO. Sin pendientes.

---

### HALLAZGOS-FASE2-SEED-202605102115.md (219L)

Todos RESUELTO o DOCUMENTADO. Sin pendientes.

---

### HALLAZGOS-FASE3-202605101800.md (375L)

| ID | Descripción breve | Tipo | Severidad | Estado en doc |
|---|---|---|---|---|
| H-F3-001 | `(( consecutivos++ ))` mata script con set -e | Código | ALTA | RESUELTO |
| H-F3-002 | ALTER USER con mysql_native_password rompe socket auth | Entorno | ALTA | RESUELTO (dual auth) |
| H-F3-003 | ERROR 1308: LEAVE with no matching label en seed_historico.sql | SQL | CRÍTICA | **PENDIENTE** |
| H-F3-004 | log_fatal no detiene el script en ciertos contextos | Código | ALTA | **PENDIENTE** |
| H-F3-005 | El seed nunca fue ejecutado — bugs enmascarados | Metodología | — | DOCUMENTADO |

**Nota:** H-F3-004 fue resuelto en FASE 4 (commit 4ded8ab — exit 1 en log_fatal).
H-F3-003 requiere verificación en el código actual de seed_historico.sql.

---

### HALLAZGOS-FASE3-ALTERNATIVA-E-202605120060.md (175L)

Todos RESUELTO o DOCUMENTADO. Sin pendientes.

---

### HALLAZGOS-FASE3-SEED-202605102130.md (210L)

Todos RESUELTO o REINICIADOS. Sin pendientes.

---

### HALLAZGOS-FASE4-202605101830.md (195L)

| ID | Descripción breve | Tipo | Severidad | Estado en doc |
|---|---|---|---|---|
| H-F4-001 | $? después de pipe captura exit de grep, no de verify.sh | Metodología | — | DOCUMENTADO |
| H-F4-002 | Contadores OK cambian al agregar verificación — 25→26 | Observación | — | DOCUMENTADO |
| H-F4-003 | Bloque 3b verifica históricas antes que analíticas | Arquitectura | BAJA | **PENDIENTE evaluación** |

**Nota:** H-F4-003 fue resuelto en FASE 4 (commit 4ded8ab — reordenamiento en verify.sh).
El documento HALLAZGOS-FASE4-202605101830 es el documento original de la sesión
de ejecución, anterior al commit. No se ha actualizado.

---

### HALLAZGOS-FASE4-ALTERNATIVA-E-202605120070.md (193L)

Hallazgos del plan Alternativa E FASE 4. Todos RESUELTO o DOCUMENTADO.
Un PENDIENTE (P=1) en el conteo automatizado corresponde al texto del propio
documento de cierre (tabla de estado anterior/final), no a un hallazgo abierto.

---

### HALLAZGOS-FASE4-SEED-202605102145.md (155L)

Todos RESUELTO o DOCUMENTADO. Sin pendientes.

---

### HALLAZGOS-FASE5-202605101900.md (312L)

| ID | Descripción breve | Tipo | Severidad | Estado en doc |
|---|---|---|---|---|
| H-F5-001 | "seed omitido" en T-5.3 es de schema_seed.sh, no de schema_historico.sh | Ambigüedad de log | MEDIA | **PENDIENTE** |
| H-F5-002 | T-5.3 no puede verificar seed por H-F3-003 | Bloqueo | ALTA | **PENDIENTE (H-F3-003)** |
| H-F5-003 | verify.sh verifica existencia de tablas, no contenido | Cobertura | BAJA | **PENDIENTE evaluación** |
| H-F5-004 | provision-mariadb.sh modificado fuera del enunciado de T-5.1 | Alcance | BAJA | DOCUMENTADO |

**Nota:** H-F5-001 y H-F5-002 dependen directamente de H-F3-003 (ERROR 1308
en seed_historico.sql). Si H-F3-003 está resuelto, estos cambian de estado.
H-F5-003 es una evaluación de diseño, no un bug.

---

### HALLAZGOS-FASE5-ALTERNATIVA-E-202605120080.md (146L)

Todos RESUELTO. Sin pendientes.

---

### HALLAZGOS-FASE6-202605101930.md (154L)

Todos RESUELTO o DOCUMENTADO. Sin pendientes.

---

### HALLAZGOS-FASE6-ALTERNATIVA-E-202605120090.md (106L)

| ID | Estado en doc |
|---|---|
| H-PKG-001 | DOCUMENTADO |
| H-PKG-002 | ACLARADO |
| H-PKG-003 | RESUELTO — Opción A con inventario en bootstrap.sh · commit a4bcf36 |

**Nota:** El PENDIENTE DECISIÓN del documento original (HALLAZGOS-PAQUETES-SISTEMA)
fue resuelto en FASE 6 pero ese documento fuente no fue actualizado.

---

### HALLAZGOS-FASE7-ALTERNATIVA-E-202605120100.md (183L)

Documento de cierre de FASE 7 generado en la sesión anterior. Contiene
19 referencias a "PENDIENTE" porque lista los estados anteriores de los
hallazgos en columna "Estado anterior". No representa hallazgos abiertos.

---

### HALLAZGOS-IACT-API-2026-05-07.md (207L)

| ID | Estado en doc |
|---|---|
| H-A-001..004 | Todos DOCUMENTADO, Cerrado o "Ninguna acción" |

---

### HALLAZGOS-JOB-ETL-SIMULACION-202605102245.md (351L)

| ID | Descripción breve | Severidad | Estado en doc |
|---|---|---|---|
| H-JOB-001 | evt_etl_diario no registra en etl_runs | ALTA | DOCUMENTADO |
| H-JOB-002 | etl_runs.status='success' aunque SP haya hecho SKIP | MEDIA | DOCUMENTADO |
| H-JOB-003 | heartbeat_at=NULL cuando SP termina antes del tick | INFO | DOCUMENTADO |
| H-JOB-004 | Heartbeat no puede matar SP en MariaDB | MEDIA | DOCUMENTADO |
| H-JOB-005 | event_scheduler requiere flag explícito — no persiste sin my.cnf | ALTA | **PENDIENTE** |

**Nota:** H-JOB-005 se refiere al mismo problema de event_scheduler que
H-SIM-005. La solución es configurar event_scheduler=ON en my.cnf.
Verificar si 99-iact.cnf ya lo incluye (config/mariadb/99-iact.cnf).

---

### HALLAZGOS-PAQUETES-SISTEMA-202605112345.md (161L)

| ID | Estado en doc |
|---|---|
| H-PKG-001 | DOCUMENTADO |
| H-PKG-002 | ACLARADO |
| H-PKG-003 | **PENDIENTE DECISIÓN** ← desactualizado; resuelto en commit a4bcf36 |

---

### HALLAZGOS-PIPELINE-ETL-COMPLETO-202605102215.md (477L)

| ID | Descripción breve | Severidad | Estado en doc |
|---|---|---|---|
| H-SP2-001 | etl_runs columnas distintas al documento | ALTA | DOCUMENTADO |
| H-SP2-002 | event_scheduler OFF — evt_etl_diario nunca dispara | ALTA | RESUELTO — event_scheduler=ON en 99-iact.cnf |
| H-SP2-003 | fn_duracion_seg no usada en SPs desplegados | MEDIA | DOCUMENTADO |
| H-SP2-004 | FLUJO-ETL-V2.1.md describe incorrectamente sp_etl_historico | BAJA | RESUELTO — FASE 5 · 5a48040 |
| H-SP2-005 | verify.sh verifica 5 de 7 funciones | BAJA | RESUELTO — FASE 4 · 4ded8ab |
| H-SP2-006 | base_ivr_* vacías — ETL histórico no ejecutado | ALTA | RESUELTO — FASE 4 · 4ded8ab |

---

### HALLAZGOS-PLAN-V2.1-CIERRE-2026-05-09.md (274L)

Sin hallazgos con PENDIENTE. Documento de cierre histórico.

---

### HALLAZGOS-PROVISION-GRANTS-202605102300.md (242L)

| ID | Estado en doc |
|---|---|
| H-GRANT-001..007 | RESUELTO o DOCUMENTADO |
| H-GRANT-008 | RESUELTO — FASE 5 · 5a48040 |

---

### HALLAZGOS-PROVISIONAMIENTO-202605101945.md (223L)

| ID | Descripción breve | Tipo | Severidad | Estado en doc |
|---|---|---|---|---|
| H-PROV-001 | `service mariadb` no mantiene proceso en contenedor sin init | Infraestructura | ALTA | DOCUMENTADO |
| H-PROV-002 | PostgreSQL sin extensiones opcionales | Infraestructura | BAJA | DOCUMENTADO |
| H-PROV-003 | H-F3-003 confirmado en provisionamiento real (ERROR 1308) | Bug pre-existente | CRÍTICA | **PENDIENTE** |

**Nota:** H-PROV-003 bloquea la misma ruta que H-F3-003 y H-F5-002.
Si H-F3-003 está resuelto en el código, H-PROV-003 también.

---

### HALLAZGOS-PROVISIONER-MARIADB-2026-05-10.md (259L)

Todos RESUELTO o DOCUMENTADO. Sin pendientes.

---

### HALLAZGOS-PROVISIONER-POSTGRES-2026-05-10.md (265L)

| ID | Descripción breve | Severidad | Estado en doc |
|---|---|---|---|
| H-PG-001 | start_service/restart_service sin fallback | CRÍTICA | RESUELTO |
| H-PG-002 | pg_hba.conf sin regla local scram-sha-256 | ALTA | RESUELTO — FASE 1 · f4a9e98 |
| H-PG-003 | Repositorio PGDG focal-pgdg hardcodeado | MEDIA | RESUELTO — os_codename dinámico |
| H-PG-004 | Inconsistencia DB_NAME vs DB_POSTGRES_NAME | MEDIA | RESUELTO — DB_NAME eliminado |
| H-PG-005 | setup.sh ejecuta main() dos veces | BAJA | RESUELTO — BASH_SOURCE guard |

---

### HALLAZGOS-SEED-SQL-202605102030.md (401L)

Sin PENDIENTE. Todos RESUELTO o DOCUMENTADO.

---

### HALLAZGOS-SEED-VOLUMEN-MENUS-202605102045.md (315L)

Sin PENDIENTE. Sin hallazgos de acción.

---

### HALLAZGOS-SEGURIDAD-MARIADB-202605101700.md (323L)

| ID | Descripción breve | Tipo | Severidad | Estado en doc |
|---|---|---|---|---|
| H-SEC-001 | Conclusión inicial incorrecta — root accesible sin password | Metodología | — | DOCUMENTADO |
| H-SEC-002 | DB_ROOT_SOCK hardcoded — no configurable | Código | MEDIA | RESUELTO — FASE 5 · 5a48040 |
| H-SEC-003 | Root bloqueado TCP — authentication_string=invalid | Entorno | MEDIA | DOCUMENTADO — comportamiento correcto |
| H-SEC-004 | Prerequisito securización no documentado en schema_historico.sh | Docs | BAJA | RESUELTO — FASE 2 · 8384bab |

---

### HALLAZGOS-SEPARACION-RESPONSABILIDADES-202605112350.md (363L)

Documento con inconsistencia interna: H-ARCH-003 aparece con dos estados
diferentes en el mismo documento:

- **L19-21:** `**Estado:** RESUELTO — commit 21eb26e`
- **L210-212:** `**Estado:** DOCUMENTADO — requiere decisión de refactoring`
- **Tabla:** `PENDIENTE DECISIÓN`

La decisión fue tomada en FASE 6 (patrón actual es válido). El documento
no refleja el estado final.

| ID | Descripción breve | Severidad | Estado en doc (inconsistente) |
|---|---|---|---|
| H-ARCH-003 | install.sh mezcla instalación con config del SO | MEDIA | PENDIENTE DECISIÓN / RESUELTO / DOCUMENTADO |
| H-ARCH-004 | postgresql-contrib correctamente en install.sh | — | CONFIRMADO |

---

### HALLAZGOS-SP-PIPELINE-202605102200.md (283L)

| ID | Descripción breve | Severidad | Estado en doc |
|---|---|---|---|
| H-SP-001 | Plan referencia sp_rpt_reportes que no existe | — | RESUELTO |
| H-SP-002 | SPs reporte leen base_ivr_*, no tbl_historico — no bug | — | DOCUMENTADO |
| H-SP-003 | base_ivr_* tienen 0 registros — ETL no ha corrido | ALTA | RESUELTO — FASE 4 · 4ded8ab |
| H-SP-004 | seed_historico_real.sql referencia FORCE_RESEED obsoleto | MEDIA | RESUELTO — FASE 5 · 5a48040 |
| H-SP-005 | verify.sh verifica solo 5 de 7 funciones | BAJA | DOCUMENTADO |

---

### GRAFO-DEPENDENCIAS-SIMULACION-ETL-202605102230.md (366L)

| ID | Descripción breve | Severidad | Estado en doc |
|---|---|---|---|
| H-SIM-001..004 | Varios — todos DOCUMENTADO o RESUELTO | — | — |
| H-SIM-005 | event_scheduler no persiste sin my.cnf | MEDIA | **PENDIENTE** |
| H-SIM-006 | Django DRF (Nivel 7) — único nivel pendiente de despliegue | ALTA | **PENDIENTE** |

**Nota:** H-SIM-005 es el mismo problema de event_scheduler que H-JOB-005.
H-SIM-006 (Django DRF) está fuera del alcance de IACT-db.

---

## SECCIÓN 3 — RESUMEN EJECUTIVO

### Hallazgos con PENDIENTE real (requieren verificación antes de marcar)

| ID | Documento | Severidad | Naturaleza |
|---|---|---|---|
| H-F3-003 | HALLAZGOS-FASE3-202605101800 | CRÍTICA | ERROR 1308 en seed_historico.sql — ¿fue corregido? |
| H-F3-004 | HALLAZGOS-FASE3-202605101800 | ALTA | log_fatal no termina — FASE 4 lo corrigió (4ded8ab) |
| H-F4-003 | HALLAZGOS-FASE4-202605101830 | BAJA | Orden 3b — FASE 4 lo corrigió (4ded8ab) |
| H-F5-001 | HALLAZGOS-FASE5-202605101900 | MEDIA | Ambigüedad de log "seed omitido" |
| H-F5-002 | HALLAZGOS-FASE5-202605101900 | ALTA | Bloqueado por H-F3-003 |
| H-F5-003 | HALLAZGOS-FASE5-202605101900 | BAJA | verify.sh cobertura (evaluación de diseño) |
| H-F0-002 | HALLAZGOS-FASE0-SEED-202605102010 | ALTA | seed_executions inconsistente con tbl_historico |
| H-F1-004 | HALLAZGOS-FASE1-SEED-202605102015 | MEDIA | SEED_ROWS ignorado |
| H-F1-005 | HALLAZGOS-FASE1-SEED-202605102015 | BAJA | script_version incorrecto en seed_executions |
| H-JOB-005 | HALLAZGOS-JOB-ETL-SIMULACION | ALTA | event_scheduler sin my.cnf — ¿resuelto por 99-iact.cnf? |
| H-SIM-005 | GRAFO-DEPENDENCIAS-SIMULACION | MEDIA | Misma causa que H-JOB-005 |
| H-SIM-006 | GRAFO-DEPENDENCIAS-SIMULACION | ALTA | Django DRF — fuera de scope de IACT-db |
| H-PROV-003 | HALLAZGOS-PROVISIONAMIENTO | CRÍTICA | Dependiente de H-F3-003 |

### Hallazgos con PENDIENTE desactualizado (el código los resolvió, el doc no)

| ID | Documento | Por qué está desactualizado |
|---|---|---|
| H-INST-001..003 | ANALISIS-ALTERNATIVA-E-202605112358 | Escrito antes de FASE 1-2; FASES 1-2 los resolvieron |
| H-PKG-003 | HALLAZGOS-PAQUETES-SISTEMA | Resuelto en FASE 6 (commit a4bcf36) |
| H-ARCH-003 | HALLAZGOS-SEPARACION-RESPONSABILIDADES | Inconsistencia interna; FASE 6 tomó la decisión |

### Documentos objetivo de T-7.1..T-7.3 (a actualizar en FASE 7)

El plan T-7.1..T-7.3 enumera estos documentos para actualizar:

**T-7.1:**
- ANALISIS-FORENSE-CODIGO-MUERTO — ya actualizado en sesión anterior ✓
- ANALISIS-PROFUNDO-ALTERNATIVA-E — ya actualizado en sesión anterior ✓

**T-7.2:**
- ANALISIS-FORENSE-ADMINER — ya actualizado en sesión anterior ✓

**T-7.3 (PLAN-DEUDA-CERO T-6.x):**
- HALLAZGOS-SP-PIPELINE — ya actualizado en sesión anterior ✓
- HALLAZGOS-PIPELINE-ETL-COMPLETO — ya actualizado en sesión anterior ✓
- HALLAZGOS-PROVISION-GRANTS — ya actualizado en sesión anterior ✓
- HALLAZGOS-PROVISIONER-POSTGRES — ya actualizado en sesión anterior ✓
- HALLAZGOS-SEGURIDAD-MARIADB — ya actualizado en sesión anterior ✓

**Documentos que el plan NO menciona pero también necesitan actualización:**
- ANALISIS-ALTERNATIVA-E-202605112358 (H-INST-001..003 desactualizados)
- HALLAZGOS-PAQUETES-SISTEMA (H-PKG-003 desactualizado)
- HALLAZGOS-SEPARACION-RESPONSABILIDADES (H-ARCH-003 inconsistente)
- HALLAZGOS-FASE3-202605101800 (H-F3-004 resuelto en FASE 4)
- HALLAZGOS-FASE4-202605101830 (H-F4-003 resuelto en FASE 4)

### Hallazgos que requieren verificación del código ANTES de marcar

Antes de marcar como RESUELTO cualquier hallazgo, verificar contra el código:

1. **H-F3-003** — ¿El ERROR 1308 en seed_historico.sql fue corregido?  
   Verificar: `grep -n "LEAVE\|label\|LOOP\|ITERATE" provisioners/mariadb/seed_historico.sql`

2. **H-JOB-005 / H-SIM-005** — ¿event_scheduler=ON está en 99-iact.cnf?  
   Verificar: `grep "event_scheduler" config/mariadb/99-iact.cnf`

3. **H-F5-001** — ¿La ambigüedad de log fue corregida en algún script?  
   Verificar en schema_seed.sh y schema_historico.sh

4. **H-F5-003** — ¿Se evaluó agregar verificación de contenido a verify.sh?  
   Decisión de diseño — no hay código que verificar

5. **H-F0-002** — ¿Fue evaluado el registro huérfano en seed_executions?

6. **H-F1-004 / H-F1-005** — ¿Fueron corregidos en schema_historico.sh?
